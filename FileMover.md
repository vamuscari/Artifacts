The original scope what to simply clone to and pull from. My desire for projects to remain consolidated in folders breaks this and need a change of how the directories are copied.
The tmux config is a good example of this. I want `.tmux.conf` to stay in the tmux folder despite it belonging to a base directory. Technically as is stands files can only be put in the root of the project.

I have considered making the file path read like `$system/location|project_folder/filename.txt`
Where the parser sliced the | plus project_folder. I feel this might make the file hard to read in the future. 
The convention of "FROM/location" "TO/Location" used by most CLI tools is probably best. 
What about spaces in file names? Don't put fukin spaces in your file names.

```{bash}
$HOME/path/filename.example
$HOME/path/folder
# I like to add the / for clarity however you don't need it.
$HOME/path/folder/

```

## Matching with Regex

[Unicode ranges](https://www.ascii-code.com/) to are good to look at when making regex statements.
I know that Linux is more flexible but honestly people should not be putting special characters in file names except _,-
That said, I'm lazy so !(33) through ~(126) is good enough for me.

```{bash}
# [\!-\~]+ is [\x21-\x7E]+
if [[ $var =~ ([\!-\~]+)[[:space:]]+ ]]; then
    var=${BASH_REMATCH[1]}
fi
```

Match one or more ASCII characters then any trailing space
re-assign var to equal only the ASCII match group
