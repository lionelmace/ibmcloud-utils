#!/bin/sh
# Uncommment to verbose
# set -x 

export EXTENSIONS="42Crunch.vscode-openapi
awehook.vscode-blink-mind
bierner.emojisense
bierner.markdown-mermaid
bpruitt-goddard.mermaid-markdown-syntax-highlighting
budparr.language-hugo-vscode
christian-kohler.path-intellisense
Dart-Code.dart-code
Dart-Code.flutter
DavidAnson.vscode-markdownlint
dbaeumer.vscode-eslint
eamodio.gitlens
EFanZh.graphviz-preview
esbenp.prettier-vscode
ffaraone.opensslutils
flowtype.flow-for-vscode
fosshaas.fontsize-shortcuts
geeklearningio.graphviz-markdown-preview
GitHub.github-vscode-theme
golang.go
hangxingliu.vscode-systemd-support
hashicorp.terraform
idleberg.openvpn
iliazeus.vscode-ansi
Infracost.infracost
IronGeek.vscode-env
jebbs.plantuml
joaompinto.vscode-graphviz
jock.svg
l2fprod.terraform-fork
luniclynx.bison
mariomatheu.syntax-project-pbxproj
mikestead.dotenv
ms-python.isort
ms-python.python
ms-python.vscode-pylance
ms-toolsai.jupyter
ms-toolsai.jupyter-keymap
ms-toolsai.jupyter-renderers
ms-toolsai.vscode-jupyter-cell-tags
ms-toolsai.vscode-jupyter-slideshow
ms-vscode-remote.remote-containers
ms-vscode-remote.remote-ssh
ms-vscode-remote.remote-ssh-edit
ms-vscode-remote.remote-wsl
ms-vscode-remote.vscode-remote-extensionpack
ms-vscode.hexeditor
ms-vscode.remote-explorer
ms-vscode.remote-server
octref.vetur
pdconsec.vscode-print
PKief.material-icon-theme
RandomFractalsInc.vscode-data-preview
redhat.java
redhat.vscode-xml
redhat.vscode-yaml
samuelcolvin.jinjahtml
seatonjiang.gitmoji-vscode
secanis.jenkinsfile-support
shd101wyy.markdown-preview-enhanced
slevesque.vscode-zipexplorer
Souche.vscode-mindmap
streetsidesoftware.code-spell-checker
tamasfe.even-better-toml
tomoyukim.vscode-mermaid-editor
VisualStudioExptTeam.intellicode-api-usage-examples
VisualStudioExptTeam.vscodeintellicode
vscjava.vscode-java-debug
vscjava.vscode-java-dependency
vscjava.vscode-java-pack
vscjava.vscode-maven
Vue.volar
vuetifyjs.vuetify-vscode
wesbos.theme-cobalt2
yzhang.markdown-all-in-one
zhouronghui.propertylist
ZixuanChen.vitest-explorer"

for extension in $EXTENSIONS
do
  code --install-extension $extension
done