#!/bin/bash

UI_INSTS=(sw lw add addi sub and andi or ori xor xori sll srl sra slli srli srai slt sltu slti sltiu beq bne blt bge bltu bgeu jal jalr lui auipc)
MI_INSTS=(csr scall)

WORK_DIR=/workspaces/mkcpu
RESULT_DIR=$WORK_DIR/results
mkdir -p $RESULT_DIR
cd $WORK_DIR

function test_all_insts(){
    INSTS=${!1}
    PACKAGE_NAME=$2
    ISA=$3
    
    for INST in ${INSTS[@]}
    do
        echo "Running test for \"$INST\" instruction..."
        sed -e "s/{isa}/$ISA/" -e "s/{inst}/$INST/" $WORK_DIR/src/test/scala/TestTemplate > $WORK_DIR/src/test/scala/TestTemp.scala
        sbt "testOnly $PACKAGE_NAME.RiscvTest" > $RESULT_DIR/$INST.txt
        rm -f $WORK_DIR/src/test/scala/TestTemp.scala
        echo "Done test for \"$INST\" instruction."
    done
}

PACKAGE_NAME=cpu
test_all_insts UI_INSTS[@] $PACKAGE_NAME ui
test_all_insts MI_INSTS[@] $PACKAGE_NAME mi