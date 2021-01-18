# base-images

Base images for app-sre projects

Every directory in this has the information to build a separate image. The [`build_images.sh`](build_deploy.sh) will be called when changes are pushed to master and will enter in every directory where the `VERSION` file has changed and will try to build and push every docker to `quay.io/app-sre/<directory name>`.
