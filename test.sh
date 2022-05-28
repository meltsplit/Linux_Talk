funcA(){
echo "a"
}
funcB(){
echo "B"
}

funcA
funcB

echo "---"
opt=A
func${opt}
echo "---"
