#
# This file is part of SubdirSrc.
#
# SubdirSrc is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# SubdirSrc is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with SubdirSrc. If not, see <http://www.gnu.org/licenses/>.

### Initialize autoconf

# Require the latest version of autoconf
AC_PREREQ([2.69])

# Provide information about package and version numbering
AC_INIT(SubdirSrc, m4_esyscmd_s([awk -e '/^Version:/ {print $2}' DESCRIPTION]))

# Supply copyright information
AC_COPYRIGHT(Copyright (C) 2018 James J Balamuta)

# Verify the correct src directory exists from where the file is being run.
AC_CONFIG_SRCDIR([src])

### Determine subdirectory source files

# Dynamically generate list of sources from subdirectories via shell
SUBDIR_SOURCES="$(cd src/ && ls core/*.cpp | tr '\n' ' ')"

# Supply it as a variable
AC_SUBST(SUBDIR_SOURCES)

### Output result

# Write to the file
AC_OUTPUT(src/Makevars)
