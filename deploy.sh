// remove everything
git -C public rm -rf .
git -C public clean -fxd

site rebuild
cp -r _site/ public/

# Go To Public folder
cd public

touch .nojekyll
# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master

# Come Back up to the Project Root
cd ..
