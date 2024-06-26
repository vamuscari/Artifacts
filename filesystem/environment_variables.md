To set variable only for current shell:

```{bash}
VARNAME="my value"
```

To set it for current shell and all processes started from current shell:

```{bash}
export VARNAME="my value"      # shorter, less portable version
```

To set it permanently for all future bash sessions add such line to your .bashrc file in your $HOME directory.

To set it permanently, and system wide (all users, all processes) add set variable in /etc/environment:

```{bash}
sudo -H gedit /etc/environment
```

Use `source ~/.bashrc` in your terminal for the changes to take place immediately.
