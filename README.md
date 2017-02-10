Steps to release new API documentation

* Edit `source/index.html.md` (maybe also `source/errros/_errors.md`)
* Commit and push your changes
* Run `deploy.sh` which copies the html and assets to the Rails project
* Switch to the Rails project and commit the new html and assets
* Deploy the Rails project to production!
