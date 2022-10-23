# mru.nvim [WIP]

Most recently used files in Neovim

## Development

Use hererocks to setup the environment:

```bash
hererocks env --luajit 2.1 --rlatest
source env/bin/activate # There are other shell options
luarocks install sqlite
```

Run tests:

```bash
make test
```
