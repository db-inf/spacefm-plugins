#!/bin/bash

echo -ne "\\e]2;less "%n"...\\a" & less -- %F
