# resq-flutter
## Instructions

**Developed in flutter**


## Workflow
We are going to use the `Gitflow`, therefore, there are going to be 2 main branches:
* master: Thi branch that will get the final updates of the code. This updates are going to be the ones that are already tested.
* develop: This branch will host all of the new features until the end of the sprint. This branch will be tested before mmerging into master.

The other branches will go under the the next categories
* `feature/`: Branches created for new features or enhancements in the application. These branches are merged into the `develop`.
* `release/`: Branches used for preparing a release version. Final testing, bug fixes, and versioning updates takes place in this branch before merging into both `master` and `develop`.
* `hotfix/`: Branches created to address critical or urgent issues in the production environment. Hotfix branches are used to make quick fixes and are merged into both `master` and `develop`.
* `bugfix/`: Similar to hotfix/, these branches are used to address non-critical bugs identified during testing or in the production environment. These branches are merged into `develop`.
* `support/`: Branches dedicated to supporting older versions of the software that may still be in use.

Any Issue apart from the `#1` (Creation of the project) might be under one of these categories. The branch name might be based on the following convention:

category/description-#:
* The category is one of the `feature`, `release`, `hotifx`, `bugfix` or `support`.
* `#` is the Issue number
* description is a word that better describes the issue. The description will only have camelCase style and will not be longer than 15 characters.

### Ex:
Issue #1

Title: Implementation of the login view

description: The login view might be developed taking into account the design. Figmalink...

the branch will be:

feature/loginView-#1
