for folder in */; do
    cd $folder
    timeout -k 1m 48h crest mol.sdf -T 32 &> crest_xtb.out
    rm -r gfnff_topo MDFILES confcross.xyz crest_dynamics.trj crest.restart crest_rotamers.xyz calculation.level.1 core &> /dev/null
    mkdir ../../part1_search_conf/${folder}
    cp crest_best.xyz ../../part1_search_conf/${folder}mol.xyz
    cd ..
done
