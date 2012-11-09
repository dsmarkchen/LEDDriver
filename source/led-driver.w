\datethis


% C++ and CppUnit type, treat the following names as types.

@s string int 
@s std int
@s CppUnit int
@s TestCase int
@s TestSuite int
@s TextTestRunner int
@s TestResult int
@s TestResultCollector int
@s TestRunner int
@s CompilerOutputter int
@s BriefTestProgressListener int

@ This program implement LED driver to explore James Grenning's LED driver example.

@c
@<includes@>@/
@<types@>@/
@<implementation@>@/
@<tests@>@/
@<main@>@/


@ @<includes@>+=
#include <cppunit/extensions/HelperMacros.h>
#include <cppunit/TestCase.h>
#include <cppunit/TestSuite.h>
#include <cppunit/TextTestRunner.h>
#include <cppunit/TestResult.h>
#include <cppunit/TestResultCollector.h>
#include <cppunit/CompilerOutputter.h>
#include <cppunit/BriefTestProgressListener.h>
#include <cppunit/extensions/TestFactoryRegistry.h>

@ @<main@>=
int main(int argc, char* argv[])
{
	CppUnit::TestResult testresult;
	CppUnit::TestResultCollector collectedresults;
	
	testresult.addListener(&collectedresults);
	CppUnit::BriefTestProgressListener progress;
    testresult.addListener (&progress);
		
	CppUnit::TestRunner	runner;
	runner.addTest (qa_led_tests::suite ());
	
	runner.run(testresult); 
	CppUnit::CompilerOutputter compileroutputter (&collectedresults, std::cerr);
	compileroutputter.write ();
	return collectedresults.wasSuccessful () ? 0 : 1; 
}
@ @<types@>+=
class qa_led_tests {
public:
	static CppUnit::TestSuite* suite();
};

@ @<imple...@>+=
CppUnit::TestSuite * qa_led_tests::suite()
{
	CppUnit::TextTestRunner runner;
	CppUnit::TestSuite *s = new CppUnit::TestSuite("qa_led_tests");
	s->addTest(CQA_LedTest::suite());	
	return s;
}

@ @<types@>+=
class CQA_LedTest : public CppUnit::TestCase {
    CPPUNIT_TEST_SUITE(CQA_LedTest);
    CPPUNIT_TEST (t1_LedsOffAfterCreate);
    CPPUNIT_TEST_SUITE_END();

    private:
    void t1_LedsOffAfterCreate();
};
	
@ @<test...@>+=
void CQA_LedTest::t1_LedsOffAfterCreate()
{
    uint16_t virtualLeds = 0xffff;
    LedDriver_Create(&virtualLeds);
    CPPUNIT_ASSERT_EQUAL((uint16_t)0, virtualLeds);
}



@ @<types@>+=
void LedDriver_Create(uint16_t* address)
{
  *address = 0;
}
void LedDriver_Destroy(void)
{

}
@ Index.
