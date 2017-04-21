#include <amxmodx>
#include <amxmisc>
#include <customshop>

#define PLUGIN_VERSION "4.1+"

new g_pFlag, g_pDiscount

public plugin_init()
{
	register_plugin("CSHOP Addon: VIP Discount", PLUGIN_VERSION, "OciXCrom")
	g_pFlag = register_cvar("cshop_discount_flag", "b")
	g_pDiscount = register_cvar("cshop_discount_amount", "-15%")
}

public cshop_set_price(id, iItem, iPrice)
{
	static szFlag[2]
	get_pcvar_string(g_pFlag, szFlag, charsmax(szFlag))
	
	if(has_flag(id, szFlag))
	{
		static szMath[8]
		get_pcvar_string(g_pDiscount, szMath, charsmax(szMath))
		return math_add(iPrice, szMath)
	}
	
	return 0
}

math_add(iNum, const szMath[])
{
	static szNewMath[16], bool:bPercent, cOperator, iMath
   
	copy(szNewMath, charsmax(szNewMath), szMath)
	bPercent = szNewMath[strlen(szNewMath) - 1] == '%'
	cOperator = szNewMath[0]
   
	if(!isdigit(szNewMath[0]))
		szNewMath[0] = ' '
   
	if(bPercent)
		replace(szNewMath, charsmax(szNewMath), "%", "")
	   
	trim(szNewMath)
	iMath = str_to_num(szNewMath)
   
	if(bPercent)
		iMath *= iNum / 100
	   
	switch(cOperator)
	{
		case '+': iNum += iMath
		case '-': iNum -= iMath
		case '/': iNum /= iMath
		case '*': iNum *= iMath
		default: iNum = iMath
	}
   
	return iNum
}  