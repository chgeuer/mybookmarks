


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
