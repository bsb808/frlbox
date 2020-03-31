# frlbox

Custom toolboxes for MATLAB.

## Install some external components

* genpath_exclude:
  * Switching to [genpath_exclude2](git@github.com:ssordopalacios/matlab-genpath2.git)
    * cd ~/WorkingCopies
    * git clone git@github.com:ssordopalacios/matlab-genpath2.git
  * Previously was using: [genpath_exclude](https://www.mathworks.com/matlabcentral/fileexchange/22209-genpath_exclude)
* [export_fig](git clone git@github.com:altmany/export_fig.git)
  * cd ~/WorkingCopies
  * git clone git@github.com:altmany/export_fig.git

## Setup startup.m

Make a link (ln -s) to startup.m in /usr/local/MATLAB/VER/toolbox/local/ or in home

```
sudo ln -s ~/WorkingCopies/frlbox/startup.m /usr/local/MATLAB/R2019b/toolbox/local/
ln -s ~/WorkingCopies/frlbox/startup.m ~
```

As of 2019b, the later seems to be the preference.

##