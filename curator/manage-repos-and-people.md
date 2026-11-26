# Manage repos and people

You need an owner of the chair's organisation to add or remove members. You also need one to create a project repo from the template when the organisation's settings do not let members create repos themselves. Where members can create repos, a researcher can [ask Claude to start a new project](../researcher/start-or-get-a-project.md#start-a-new-project), and giving the team of all members the role **Write** (steps 5 and 6 below) stays yours.

Claude has no part in the tasks on this page. The button names follow GitHub's documentation, and no trial here has confirmed them.

## Create a project repo from the template

1. On github.com, open `project-template`. Click **Use this template** and choose **Create a new repository**.
2. Under **Owner**, choose the chair's organisation.
3. Under **Repository name**, type the project's bare name.
4. Choose **Private**, and click **Create repository from template**.
5. In the new repo, open **Settings**, then **Collaborators & teams**, and click **Add teams**.
6. Pick the team of all members, and give it the role **Write**.

The new repo copies the template's files as they are; do not edit them before its first run. Later changes to the template do not reach it, so each project keeps the `ado/` files and rules that made its results.

## Welcome a new researcher

1. [Add the person as a member](#add-a-member).
2. Make them a practice project with the six steps above. They use it for [Your first day](../start/first-day.md).
3. Give them the data root and a Claude account.

Step 3 is not yet settled. The data root is to be a Dropbox team folder, where members view `raw/` and `processed/` and edit `intermediate/`. That team account, and a Claude account for each researcher, are still open.

## Add a member

1. On the organisation's page, open **Teams**, then the team of all members.
2. Open **Members** and click **Add a member**.
3. Type the person's GitHub user name, or their email address, and confirm.

Someone new to the organisation gets an invitation by email, and joins on accepting it.

## Add an outside co-author

1. In the project's repo, open **Settings**, then **Collaborators & teams**, and click **Add people**.
2. Type their user name, and give them the role **Write**.

They join no team. You decide which data they receive, by each source's terms of use.

## Remove someone

- **From the organisation.** Open **People**, select the person, and choose **Remove from organization**.
- **From one team.** Open **Teams**, then the team, select the person, and choose **Remove from team**.
