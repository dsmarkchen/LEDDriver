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
    CPPUNIT_TEST (t1_leds_off_after_create);
    CPPUNIT_TEST (t2_turn_on_led_one);
    CPPUNIT_TEST (t3_turn_off_led_one);
    CPPUNIT_TEST (t4_turn_on_multiple_leds);
    CPPUNIT_TEST (t5_turn_off_any_leds);
    CPPUNIT_TEST (t6_upper_lower_bounds);
    CPPUNIT_TEST (t7_turn_all_on);
    CPPUNIT_TEST (t8_turn_all_off);
    CPPUNIT_TEST (t9_turn_off_any_led);
    CPPUNIT_TEST (t10_turn_off_out_of_bound);
    CPPUNIT_TEST (t11_turn_off_out_of_bound);
    CPPUNIT_TEST_SUITE_END();

    private:
    void t1_leds_off_after_create();
    void t2_turn_on_led_one();
    void t3_turn_off_led_one();
    void t4_turn_on_multiple_leds();
    void t5_turn_off_any_leds();
    void t6_upper_lower_bounds();
    void t7_turn_all_on();
    void t8_turn_all_off();
    void t9_turn_off_any_led();
    void t10_turn_off_out_of_bound();
    void t11_turn_off_out_of_bound();
};
	
@ @<test...@>+=
void CQA_LedTest::t1_leds_off_after_create()
{
    uint16_t virtualLeds = 0xffff;
    LedDriver_Create(&virtualLeds);
    CPPUNIT_ASSERT_EQUAL((uint16_t)0, virtualLeds);
}



@ @<types@>+=
void LedDriver_Create(uint16_t* address);
void LedDriver_Destroy(void);

@ @<impl...@>+=
static uint16_t* ledsAddress;
void LedDriver_Create(uint16_t* address)
{
    ledsAddress = address;
    *ledsAddress = 0;
}
void LedDriver_Destroy(void)
{

}

@ Turn on Led 1.

@<impl...@>+=
void CQA_LedTest::t2_turn_on_led_one()
{
    uint16_t virtualLeds;
    LedDriver_Create(&virtualLeds);
    LedDriver_TurnOn(1);
    CPPUNIT_ASSERT_EQUAL((uint16_t)1, virtualLeds);

}

@ @<type...@>+=
void  LedDriver_TurnOn(int lednumber);


@ @<imple...@>+=
void  LedDriver_TurnOn(int lednumber)
{
     uint16_t val = *ledsAddress ;
    *ledsAddress = val | (uint16_t) 1<<(lednumber-1);
}


@ Turn off leds one.
@<impl...@>+=
void CQA_LedTest::t3_turn_off_led_one()
{
    uint16_t virtualLeds;
    LedDriver_Create(&virtualLeds);
    LedDriver_TurnOn(1);
    LedDriver_TurnOff(1);
    CPPUNIT_ASSERT_EQUAL((uint16_t)0, virtualLeds);

}

@ @<type...@>+=
void  LedDriver_TurnOff(int lednumber);


@ @<imple...@>+=
void  LedDriver_TurnOff(int lednumber)
{
     uint16_t val = *ledsAddress ;
     uint16_t led_val = (uint16_t) 1<<(lednumber-1);
     *ledsAddress &= ~led_val;
}


@  @<impl...@>+=
void CQA_LedTest::t4_turn_on_multiple_leds()
{
    uint16_t virtualLeds;
    LedDriver_Create(&virtualLeds);
    LedDriver_TurnOn(9);
    LedDriver_TurnOn(8);
    CPPUNIT_ASSERT_EQUAL((uint16_t)0x180, virtualLeds);
}

@  @<impl...@>+=
void CQA_LedTest::t5_turn_off_any_leds()
{
    uint16_t virtualLeds;
    LedDriver_Create(&virtualLeds);
    LedDriver_TurnOn(9);
    LedDriver_TurnOn(8);
    LedDriver_TurnOff(8);
    CPPUNIT_ASSERT_EQUAL((uint16_t)0x100, virtualLeds);
}


@ Boundary check.
@<impl...@>+=
void CQA_LedTest::t6_upper_lower_bounds()
{
    uint16_t virtualLeds;
    LedDriver_Create(&virtualLeds);
    LedDriver_TurnOn(1);
    LedDriver_TurnOn(16);
    CPPUNIT_ASSERT_EQUAL((uint16_t)0x8001, virtualLeds);
}

@ Turn all on.
@<impl...@>+=
void CQA_LedTest::t7_turn_all_on()
{
    uint16_t virtualLeds;
    LedDriver_Create(&virtualLeds);
    LedDriver_TurnAllOn();
    CPPUNIT_ASSERT_EQUAL((uint16_t)0xffff, virtualLeds);
} 
@ @<types@>+=
void LedDriver_TurnAllOn();
void LedDriver_TurnAllOff();

@ @<impl...@>+=
void LedDriver_TurnAllOn()
{
    *ledsAddress = (uint16_t)0xffff;
}

@ turn all off.
@<impl...@>+=
void CQA_LedTest::t8_turn_all_off()
{
    uint16_t virtualLeds;
    LedDriver_Create(&virtualLeds);
    LedDriver_TurnAllOff();
    CPPUNIT_ASSERT_EQUAL((uint16_t)0x0, virtualLeds);
}
@ @<impl...@>+=
void LedDriver_TurnAllOff()
{
    *ledsAddress = 0;
}
@ turn off any leds.
@<impl...@>+=
void CQA_LedTest::t9_turn_off_any_led()
{
    uint16_t virtualLeds;
    LedDriver_Create(&virtualLeds);
    LedDriver_TurnAllOn();
    LedDriver_TurnOff(8);
    CPPUNIT_ASSERT_EQUAL((uint16_t)0xff7f, virtualLeds);
}

@ Out of bound turn off do not hard.
@<impl...@>+=
void CQA_LedTest::t10_turn_off_out_of_bound()
{
    uint16_t virtualLeds;
    LedDriver_Create(&virtualLeds);
    LedDriver_TurnOff(-1);
    LedDriver_TurnOff(17);
    LedDriver_TurnOff(3141);
    LedDriver_TurnOff(0);
    CPPUNIT_ASSERT_EQUAL((uint16_t)0, virtualLeds);
}
@ @<impl...@>+=
void CQA_LedTest::t11_turn_off_out_of_bound()
{
    uint16_t virtualLeds;
    LedDriver_Create(&virtualLeds);
    LedDriver_TurnAllOn();
    LedDriver_TurnOff(-1);
    LedDriver_TurnOff(17);
    LedDriver_TurnOff(3141);
    LedDriver_TurnOff(0);
    CPPUNIT_ASSERT_EQUAL((uint16_t)0xffff, virtualLeds);
}

@
@d RUNTIME_ERROR(description, parameter) RunTimeError(description, parameter, __FILE__, __LINE__)
@<type...@>+=
void RunTimeError(const char* message, int parameter, const char* file, int line);

@ mocks Runtime Error stub.
@<type...@>+=
void RunTimeErrorStub_reset(void);
const char* RunTimeErrorStub_GetLastError(void);
int RunTimeErrorStub_GetLastParameter(void);



@ Run time error stub
@<impl...@>+=
static const char* message = "No Error";
static int parameter = -1;
static const char* file = 0;
static int line = -1;

void RunTimeErrorStub_reset(void)
{
    message == "No Error";
    parameter = -1;
}


@ @<impl...@>+=
const char* RunTimeErrorStub_GetLastError(void)
{
    return message;
}
int RunTimeErrorStub_GetLastParameter(void)
{
    return parameter;
}
void RunTimeError(const char* m, int p, const char* f, int l)
{
    message = m;
    parameter = p;
    file = f;
    line = l;
}
@ Index.
