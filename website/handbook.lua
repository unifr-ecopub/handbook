-- The handbook's look on the website.
--
-- What it does: Quarto runs this filter on every page while the workflow in
-- .github/workflows/publish.yml renders the website. It changes only how a
-- page looks there; the Markdown files, and how github.com shows them, stay
-- as they are.
--
--   1. The first paragraph under a page's title becomes the page's lead.
--   2. A task's labels (Ask Claude., Claude will ask you., Only you do.,
--      Check.) become one card, with each label as a small heading and the
--      request in a grey box like a chat message. The code blocks and lists
--      just after a label belong to it.
--   3. What can go wrong. and Untested on Windows. become coloured boxes.
--   4. A heading such as "1. Pull" shows its number in grey.
--   5. A list whose every line is one link becomes a list of rows.
--   6. The start page's table of roles (a picture in the first column)
--      becomes one card per role, with a button to its first page.
--   7. Each code block goes in a box that names its language, with buttons
--      to wrap its lines and copy it (website/code-boxes.html adds them).
--      The request to Claude is a grey box with only the copy button.
--   8. Each diagram (```mermaid) is left for pele to draw in the browser
--      (website/diagrams.html), instead of Quarto.
--
-- The look of each of these is in website/handbook.scss.

local LABELS = {
  ["Ask Claude."] = "ask",
  ["Claude will ask you."] = "asks",
  ["Only you do."] = "you",
  ["Check."] = "check",
  ["What can go wrong."] = "wrong",
  ["Untested on Windows."] = "untested",
}

-- The labels that together make a task's card.
local IN_TASK = { ask = true, asks = true, you = true, check = true }

-- The label a paragraph opens with, and its kind; nil if it opens with none.
local function label_of(block)
  if block.t ~= "Para" then return nil end
  local first = block.content[1]
  if not first or first.t ~= "Strong" then return nil end
  local text = pandoc.utils.stringify(first)
  local kind = LABELS[text]
  if not kind then return nil end
  return text, kind
end

local function is_blank(inline)
  return inline.t == "Space" or inline.t == "SoftBreak" or inline.t == "LineBreak"
end

-- One labelled block: the label as a small heading, the rest of the
-- paragraph, and the code blocks and lists that follow it.
local function labelled(blocks, i)
  local text, kind = label_of(blocks[i])
  local rest = blocks[i].content:clone()
  rest:remove(1)
  while #rest > 0 and is_blank(rest[1]) do rest:remove(1) end

  local inner = pandoc.Blocks{}
  inner:insert(pandoc.Div(pandoc.Plain{ pandoc.Str(text:sub(1, -2)) },
    pandoc.Attr("", { "hb-label" })))
  if #rest > 0 then inner:insert(pandoc.Para(rest)) end

  i = i + 1
  while i <= #blocks do
    local t = blocks[i].t
    if t == "CodeBlock" or t == "BulletList" or t == "OrderedList" then
      if t == "CodeBlock" and kind == "ask" then
        blocks[i].classes:insert("hb-request")
      end
      inner:insert(blocks[i])
      i = i + 1
    else
      break
    end
  end
  return pandoc.Div(inner, pandoc.Attr("", { "hb-block", "hb-" .. kind })), kind, i
end

-- Labels in a row of blocks: each labelled block is built, and those that
-- follow one another and belong to a task are put in one card.
local function labels(blocks)
  local out = pandoc.Blocks{}
  local card = nil
  local function close_card()
    if card then out:insert(pandoc.Div(card, pandoc.Attr("", { "hb-task" }))) end
    card = nil
  end
  local i = 1
  while i <= #blocks do
    if label_of(blocks[i]) then
      local div, kind, next_i = labelled(blocks, i)
      if IN_TASK[kind] then
        card = card or pandoc.Blocks{}
        card:insert(div)
      else
        close_card()
        out:insert(div)
      end
      i = next_i
    else
      close_card()
      out:insert(blocks[i])
      i = i + 1
    end
  end
  close_card()
  return out
end

-- The first paragraph of the page, before any section, is its lead.
local function lead(blocks)
  for i = 1, math.min(2, #blocks) do
    local b = blocks[i]
    if b.t == "Para" and not label_of(b) then
      blocks[i] = pandoc.Div({ b }, pandoc.Attr("", { "hb-lead" }))
      return blocks
    end
    if not (b.t == "Header" and b.level == 1) then return blocks end
  end
  return blocks
end

-- "1. Pull" shows its number apart, in grey.
local function numbered(h)
  local first = h.content[1]
  if h.level ~= 2 or not first or first.t ~= "Str" then return nil end
  local n = first.text:match("^(%d+)%.$")
  if not n then return nil end
  local content = h.content:clone()
  content:remove(1)
  while #content > 0 and is_blank(content[1]) do content:remove(1) end
  content:insert(1, pandoc.Space())
  content:insert(1, pandoc.Span({ pandoc.Str(n) }, pandoc.Attr("", { "hb-step" })))
  h.content = content
  return h
end

-- A list whose every line is one link.
local function only_links(list)
  for _, item in ipairs(list.content) do
    if #item ~= 1 then return false end
    local b = item[1]
    if b.t ~= "Plain" and b.t ~= "Para" then return false end
    local links, other = 0, 0
    for _, inline in ipairs(b.content) do
      if inline.t == "Link" then
        links = links + 1
      elseif not is_blank(inline) then
        other = other + 1
      end
    end
    if links ~= 1 or other ~= 0 then return false end
  end
  return #list.content > 0
end

local function link_rows(list)
  if only_links(list) then
    return pandoc.Div({ list }, pandoc.Attr("", { "hb-links" }))
  end
end

-- The table of roles on the start page: a picture, who you are, where to
-- start. Any other table is left as it is.
local function role_cards(tbl)
  local cards = pandoc.Blocks{}
  for _, body in ipairs(tbl.bodies) do
    for _, row in ipairs(body.body) do
      local cells = row.cells
      if #cells ~= 3 then return nil end
      local img = nil
      pandoc.Div(cells[1].contents):walk({
        Image = function(el) img = el end,
      })
      local link = nil
      pandoc.Div(cells[3].contents):walk({
        Link = function(el) link = el end,
      })
      if not img or not link then return nil end

      local who = pandoc.utils.stringify(cells[2].contents)
      local title = pandoc.utils.stringify(img.caption)
      local icon = pandoc.Image({}, img.src)
      link.attr = pandoc.Attr("", { "hb-button" })

      cards:insert(pandoc.Div({
        pandoc.Div({
          pandoc.Div(pandoc.Plain{ icon }, pandoc.Attr("", { "hb-card-icon" })),
          pandoc.Div({
            pandoc.Div(pandoc.Plain{ pandoc.Str(title) }, pandoc.Attr("", { "hb-card-title" })),
            pandoc.Div(pandoc.Plain{ pandoc.Str("If you are " .. who) }, pandoc.Attr("", { "hb-card-meta" })),
          }),
        }, pandoc.Attr("", { "hb-card-head" })),
        pandoc.Div(pandoc.Plain{ pandoc.Str("Start with") }, pandoc.Attr("", { "hb-card-start" })),
        pandoc.Plain{ link },
      }, pandoc.Attr("", { "hb-card" })))
    end
  end
  if #cards == 0 then return nil end
  return pandoc.Div(cards, pandoc.Attr("", { "hb-cards" }))
end

local function escape_html(text)
  return (text:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

-- A diagram, for pele; any other code block, in its box.
local function code_box(block)
  local lang = block.classes[1] or "text"
  if lang == "mermaid" then
    return pandoc.RawBlock("html",
      '<pre class="hb-mermaid">' .. escape_html(block.text) .. "</pre>")
  end
  if lang == "plaintext" or lang == "hb-request" then lang = "text" end
  local classes = { "hb-code" }
  if block.classes:includes("hb-request") then
    table.insert(classes, "hb-request-box")
  end
  return pandoc.Div({ block }, pandoc.Attr("", classes, { ["data-lang"] = lang }))
end

return {
  {
    Header = numbered,
    BulletList = link_rows,
    Table = role_cards,
  },
  {
    Pandoc = function(doc)
      doc.blocks = labels(lead(doc.blocks))
      return doc
    end,
  },
  {
    CodeBlock = code_box,
  },
}
