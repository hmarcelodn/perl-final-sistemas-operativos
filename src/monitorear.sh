#!/bin/bash
ultimo_log=$(cd ../logs && ls -1tr * | tail -1)
tail -f ../logs/"$ultimo_log"
