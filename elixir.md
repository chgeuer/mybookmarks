
# Instruct `mix` to use a local fiddler instance as proxy

```
mix hex.config http_proxy http://127.0.0.1:8888
mix hex.config https_proxy http://127.0.0.1:8888
mix hex.config unsafe_https true

rm ~/.hex/hex.config
```



# Use pragdave's templating system

```bash
mix archive.install hex mix_templates
mix archive.install hex mix_generator

mix template
mix template.hex 

mix template.install hex gen_template_project
mix template.install hex gen_template_umbrella
mix template.install hex gen_template_template

mix gen project my_app
mix gen project my_supervised --sup
mix gen project my_supervised --umbrella
mix gen umbrella my_umbrella
```


# Install Erlang and Elixir on Windows WSL (Creator Update)

```bash
sudo su

apt-get install build-essential git wget libssl-dev libreadline-dev libncurses5-dev zlib1g-dev m4 curl wx-common libwxgtk3.0-dev autoconf

cd
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.2.1

echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc
chmod +x $HOME/.asdf/asdf.sh
echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
chmod +x $HOME/.asdf/completions/asdf.bash

asdf install erlang 19.3
asdf global  erlang 19.3

asdf install elixir 1.4.2
asdf global  elixir 1.4.2
```

- https://groups.google.com/forum/#!topic/elixir-lang-talk/zobme8NvlZ4

- https://raw.githubusercontent.com/chgeuer/mybookmarks/master/elixir-nerves-on-ubuntu/provision-nerves-on-ubuntu-16.04.sh
- ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/releases/download/${ELIXIR_VERSION}/Precompiled.zip"


```
wget http://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc
sudo apt-key add erlang_solutions.asc
```

# There is as of now no erlang download for xenial, so we have to hard code wily.

```
sudo add-apt-repository "deb http://packages.erlang-solutions.com/ubuntu wily contrib"
```

# sudo add-apt-repository "deb http://packages.erlang-solutions.com/ubuntu $(lsb_release -s -c) contrib"

```
sudo apt-get update
yes Y | sudo apt-get -y install esl-erlang
sudo apt-get -y install elixir

mix local.hex --force
mix local.rebar --force
mix archive.install "https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez" --force
```

- https://nodejs.org/dist/v6.10.2/node-v6.10.2-linux-x64.tar.xz
