# !/bin/zsh
echo 'CM.make "sources.cm";
Tester.testFirst();
Tester.testLast();
Tester.testPrev();
Tester.testNext();
Tester.testJoin();
Tester.testSplit();
Tester.testRange();
Tester.testCount()' | sml
