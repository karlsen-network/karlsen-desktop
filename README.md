# Karlsen Desktop

[![GitHub release](https://img.shields.io/github/v/release/karlsen-network/karlsen-desktop.svg)](https://github.com/karlsen-network/karlsen-desktop/releases)
[![GitHub downloads](https://img.shields.io/github/downloads/karlsen-network/karlsen-desktop/total.svg)](https://github.com/karlsen-network/karlsen-desktop/releases)
[![Join the Karlsen Discord Server](https://img.shields.io/discord/1169939685280337930.svg?label=&logo=discord&logoColor=ffffff)](https://discord.gg/ZPZRvgMJDT)

Karlsen Desktop is a dedicated desktop process manager for
[Karlsen node](https://github.com/karlsen-network/karlsend).

Karlsen Desktop process configuration (available via a simple JSON
editor) allows user to specify command-line arguments for executables,
as such it is possible to configure it to run multiple instances of
Karlsen or potentially run multiple networks simultaneously (provided
Karlsen nodes do not pro-actively auto-discover each-other).

Like many desktop applications, Karlsen Desktop can run in the tray
bar, out of the way.

Karlsen Desktop is built using [NWJS](https://nwjs.io) and is
compatible Windows, Linux and Mac OS X.

## Building Karlsen Desktop

### Pre-requisites

* [Node.js 14.0.0+](https://nodejs.org/)
* [Emanator](https://www.npmjs.com/package/emanator)

**NOTE:** Karlsen Desktop build process builds and includes latest
Karlsen binaries from Git master branches. To build from specific
branches, you can use `--branch...` flags (see below).

### Generating Karlsen Desktop installers

To build and deploy Karlsen Desktop production-ready builds, do the
following:

```
mkdir karlsen-build
cd karlsen-build
npm install emanator@latest
git clone https://github.com/karlsen-network/karlsen-desktop
cd karlsen-desktop
```

Emanator will help to create standalone desktop applications using
NWJS. It accepts the following flags:

* `--portable` will create a portable zipped application.
* `--innosetup` will generate Windows setup executable.
* `--dmg` will generate a DMG image for macOS.
* `--all` will generate all OS compatible packages.

Additionally the following flags can be used to reset the environment:

* `--clean` clean build folders: purges cloned `GOPATH` folder
* `--reset` deletes downloaded/cached NWJS and NODE binaries

The `--clean` and `--reset` can be combined to cleanup build folder
and cached files.

DMG - Building DMG images on macOS requires `sudo` access in order to
use system tools such as `diskutil` to generate images: 

```
sudo ../node_modules/.bin/emanate build --dmg
```

To build the Windows portable deployment, run the following command:

```
../node_modules/.bin/emanate build --archive --portable
```

To build the Windows installer, you need to install
[Innosetup](https://jrsoftware.org/isdl.php) and run:

```
../node_modules/.bin/emanate build --innosetup
```

Emanator stores build files in the `~/emanator` folder.

### Running Karlsen Desktop from development environment

In addition to Node.js (must be 14.0+), please download and install
[Latest NWJS SDK https://nwjs.io](https://nwjs.io/) - make sure that
`nw` executable is available in the system PATH and that you can run
`nw` from command line.

On Linux / Darwin, as good way to install `node` and `nwjs` is as
follows:

```
cd ~/
mkdir bin
cd bin

wget https://nodejs.org/dist/v14.4.0/node-v14.4.0-linux-x64.tar.xz
tar xvf node-v14.4.0-linux-x64.tar.xz
ln -s node-v14.4.0-linux-x64 node

wget https://dl.nwjs.io/v0.46.2/nwjs-sdk-v0.46.2-linux-x64.tar.gz
tar xvf nwjs-sdk-v0.46.2-linux-x64.tar.gz
ln -s nwjs-sdk-v0.46.2-linux-x64 nwjs

```
Once done add the following to `~/.bashrc`

```
export PATH="~/bin/node/bin:~/bin/nwjs:${PATH}"
```

The above method allows you to deploy latest binaries and manage
versions by re-targeting symlinks pointing to target folders.
Once you have `node` and `nwjs` working, you can continue with
Karlsen Desktop.

Karlsen Desktop installation:

```
git clone https://github.com/karlsen-network/karlsen-desktop
cd karlsen-desktop
npm install
npm install emanator@latest
node_modules/.bin/emanate --local-binaries
nw .
```

### Building installers from specific Karlsen Git branches

The `--branch` argument specifies common branch name for Karlsen, for
example:

```
node_modules/.bin/emanate --branch=2024_initial_karlsen_support
```

The branch for each repository can be overriden using
`--branch-<repo-name>=<branch-name>` arguments as follows:

```
emanate --branch=2024_initial_karlsen_support --branch-karlsend=2024_fixes_next
```

## Karlsen Desktop Process Manager

### Configuration

Karlsen Desktop runtime configuration is declared using a JSON object.

Each instance of the process is declared using it's **type** (for
example: `karlsend`) and a unique **identifier** (`kd0`). Most
process configuration objects support `args` property that allows
passing arguments or configuration options directly to the process
executable. The configuration is passed via configuration file
(karlsend).

Supported process types:
- `karlsend` - Karlsen full node

**NOTE:** For Karlsen, to specify multiple connection endpoints,
you must use an array of addresses as follows: `"args" : { "connect" : [ "peer-addr-port-a", "peer-addr-port-b", ...] }`

### Default Configuration File

```js
{
	"description": "Karlsend Node",
	"modules": {
		"karlsend:kd0": {
			"reset-peers": false,
			"args": {
				"rpclisten": "0.0.0.0:42110",
				"listen": "0.0.0.0:42111",
				"profile": 8110
			},
			"upnpEnabled": true
		}
	},
	"ident": "karlsend-node-only",
	"network": "mainnet",
	"upnpEnabled": true,
	"dataDir": "",
	"theme": "light",
	"invertTerminals": false,
	"compounding": {
		"auto": false,
		"useLatestAddress": false
	}
}
```

### Data Storage

Karlsen Desktop stores it's configuration file as
`~/.karlsen-desktop/config.json`. Each configured process data is
stored in `<datadir>/<process-type>-<process-identifier>` where
`datadir` is a user-configurable location.  The default `datadir`
location is `~/.karlsen-desktop/data/`.  For example, `karlsend`
process with identifier `kd0` will be stored in
`~/.karlsen-desktop/data/karlsend-kd0/` and it's logs in
`~/.karlsen-desktop/data/karlsend-kd0/logs/karlsend.log`.

### Karlsen Binaries

Karlsen Desktop can run Karlsen from two locations:

1. From integrated `bin` folder that is included with Karlsen
   Desktop redistributables.
2. Fron `~/.karlsen-desktop/bin` folder that is created during
   the Karlsen build process.
