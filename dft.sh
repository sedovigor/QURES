for dir in ./*/
do
cd $dir
cp ../../r2scan.inp ../../d4tzvp.inp ./

otool_xtb mol.xyz -c 0 -u 0 --namespace xtb2 --ohess extreme --molden --esp > xtb2.log
for i in {0..99}
do
if grep -q significant xtb2.log; then
  otool_xtb xtb2.xtbhess.xyz -c 0 -u 0 --namespace xtb2 --ohess extreme --molden --esp > xtb2.log
fi
done

$HOME/orca/orca r2scan.inp > r2scan.out
for i in {0..4}
do
if grep -q imaginary r2scan.out; then
    python -m pyqrc ./r2scan.out --amp 0.$((i+2))
    for file in r2scan*; do
        mv "$file" "$i$file.$i"
    done
    head -n -1 ../../r2scan.inp > ./r2scan.inp
    sed -n '6, 1000p' _QRC.inp >> r2scan.inp
    rm _QRC.*
    $HOME/orca/orca r2scan.inp > r2scan.out
fi
done

if grep -q imaginary r2scan.out; then
    touch imaginary
fi
$HOME/orca/orca d4tzvp.inp > d4tzvp.out

cd ../../
done
