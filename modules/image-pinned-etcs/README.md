# `image-pinned-etcs` Module

The `image-pinned-etcs` module simplifies the process of adding /etc files that are always up-to-date with the image maintainer supplied file. The added files are sourced from the `config/image-pinned-etcs` directory. It works by creating symlinks that point to `/usr/share/bluebuild/image-pinned-etcs/`, which is immutable. This means that the admin of the end user machine cannot change the file unless deleted and copied over from `/usr/etc/`.

## Example Configuration

```yaml
type: image-pinned-etcs
add:
  - common
```

In the example above, `common` represents the directory located inside the `config/image-pinned-etcs` in the repository. This `config/image-pinned-etcs/common` directory includes all etc configurations. In this example, if you want a symlink to be created on the end user machine at `/etc/profile.d/abc.sh` then you would create the `abc.sh` file at `config/image-pinned-etcs/common/profile.d/abc.sh`.
