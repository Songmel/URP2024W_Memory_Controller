// file = 0; split type = patterns; threshold = 100000; total count = 0.
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include "rmapats.h"

void  hsG_0__0 (struct dummyq_struct * I1352, EBLK  * I1347, U  I709);
void  hsG_0__0 (struct dummyq_struct * I1352, EBLK  * I1347, U  I709)
{
    U  I1612;
    U  I1613;
    U  I1614;
    struct futq * I1615;
    struct dummyq_struct * pQ = I1352;
    I1612 = ((U )vcs_clocks) + I709;
    I1614 = I1612 & ((1 << fHashTableSize) - 1);
    I1347->I754 = (EBLK  *)(-1);
    I1347->I755 = I1612;
    if (0 && rmaProfEvtProp) {
        vcs_simpSetEBlkEvtID(I1347);
    }
    if (I1612 < (U )vcs_clocks) {
        I1613 = ((U  *)&vcs_clocks)[1];
        sched_millenium(pQ, I1347, I1613 + 1, I1612);
    }
    else if ((peblkFutQ1Head != ((void *)0)) && (I709 == 1)) {
        I1347->I757 = (struct eblk *)peblkFutQ1Tail;
        peblkFutQ1Tail->I754 = I1347;
        peblkFutQ1Tail = I1347;
    }
    else if ((I1615 = pQ->I1255[I1614].I777)) {
        I1347->I757 = (struct eblk *)I1615->I775;
        I1615->I775->I754 = (RP )I1347;
        I1615->I775 = (RmaEblk  *)I1347;
    }
    else {
        sched_hsopt(pQ, I1347, I1612);
    }
}
void  hs_0_M_13_21__simv_daidir (UB  * pcode, scalar  val)
{
    if (*(pcode + 2) == val) {
        if (fRTFrcRelCbk) {
            U  I1434 = 0;
            if (fScalarIsForced) {
                I1434 = 29;
            }
            else if (fScalarIsReleased) {
                I1434 = 30;
            }
            if ((fScalarIsForced || fScalarIsReleased) && fRTFrcRelCbk && *(RP  *)((pcode + 8))) {
                RP  I1479 = (RP )(pcode + 8);
                void * I1480 = hsimGetCbkMemOptCallback(I1479);
                if (I1480) {
                    SDaicbForHsimCbkMemOptNoFlagFrcRel(I1480, I1434, -1, -1, -1);
                }
                fScalarIsForced = 0;
                fScalarIsReleased = 0;
            }
        }
        return  ;
    }
    *(pcode + 2) = val;
    if (fRTFrcRelCbk) {
        U  I1434 = 0;
        if (fScalarIsForced) {
            I1434 = 29;
        }
        else if (fScalarIsReleased) {
            I1434 = 30;
        }
        if ((fScalarIsForced || fScalarIsReleased) && fRTFrcRelCbk && *(RP  *)((pcode + 8))) {
            RP  I1479 = (RP )(pcode + 8);
            void * I1480 = hsimGetCbkMemOptCallback(I1479);
            if (I1480) {
                SDaicbForHsimCbkMemOptNoFlagFrcRel(I1480, I1434, -1, -1, -1);
            }
            fScalarIsForced = 0;
            fScalarIsReleased = 0;
        }
    }
    {
        {
            RP  I1539;
            RP  * I745 = (RP  *)(pcode + 8);
            {
                I1539 = *I745;
                if (I1539) {
                    hsimDispatchCbkMemOptNoDynElabS(I745, val, 0U);
                }
            }
        }
    }
    {
        RmaNbaGate1  * I1448 = (RmaNbaGate1  *)(pcode + 16);
        U  I1449 = (((I1448->I5) >> (16)) & ((1 << (1)) - 1));
        scalar  I1076 = X4val[val];
        if (I1449) {
            I1448->I1082.I855 = (void *)((RP )(((RP )(I1448->I1082.I855) & ~0x3)) | (I1076));
        }
        else {
            I1448->I1082.I856.I831 = I1076;
        }
        NBA_Semiler(0, &I1448->I1082);
    }
}
void  hs_0_M_13_0__simv_daidir (UB  * pcode, scalar  val)
{
    UB  * I1679;
    *(pcode + 0) = val;
    if (*(pcode + 1)) {
        return  ;
    }
    hs_0_M_13_21__simv_daidir(pcode, val);
    fScalarIsReleased = 0;
}
void  hs_0_M_13_1__simv_daidir (UB  * pcode, scalar  val, U  I701, scalar  * I1367, U  did)
{
    U  I1346 = 0;
    *(pcode + 1) = 1;
    fScalarIsForced = 1;
    hs_0_M_13_21__simv_daidir(pcode, val);
    fScalarIsForced = 0;
}
void  hs_0_M_13_2__simv_daidir (UB  * pcode)
{
    scalar  val;
    fScalarIsReleased = 1;
    val = *(pcode + 0);
    *(pcode + 1) = 0;
    hs_0_M_13_21__simv_daidir(pcode, val);
    fScalarIsReleased = 0;
}
void  hs_0_M_13_11__simv_daidir (UB  * pcode, scalar  val)
{
    *(pcode + 0) = val;
    if (*(pcode + 1)) {
        return  ;
    }
    hs_0_M_13_21__simv_daidir(pcode, val);
    fScalarIsReleased = 0;
}
void  hs_0_M_33_21__simv_daidir (UB  * pcode, scalar  val)
{
    if (*(pcode + 2) == val) {
        if (fRTFrcRelCbk) {
            U  I1434 = 0;
            if (fScalarIsForced) {
                I1434 = 29;
            }
            else if (fScalarIsReleased) {
                I1434 = 30;
            }
            {
                if (fScalarIsForced || fScalarIsReleased) {
                    U  ** I1476 = (U  **)(pcode + 16);
                    U  I1477 = !(((UP )(*I1476)) & 1);
                    if (I1477) {
                        if (*I1476) {
                            SDaicbForHsimCbkMemOptNoFlagDynElabFrcRel(*I1476, I1434, -1, -1, -1);
                        }
                    }
                    fScalarIsForced = 0;
                    fScalarIsReleased = 0;
                }
            }
        }
        return  ;
    }
    *(pcode + 2) = val;
    if (fRTFrcRelCbk) {
        U  I1434 = 0;
        if (fScalarIsForced) {
            I1434 = 29;
        }
        else if (fScalarIsReleased) {
            I1434 = 30;
        }
        {
            if (fScalarIsForced || fScalarIsReleased) {
                U  ** I1476 = (U  **)(pcode + 16);
                U  I1477 = !(((UP )(*I1476)) & 1);
                if (I1477) {
                    if (*I1476) {
                        SDaicbForHsimCbkMemOptNoFlagDynElabFrcRel(*I1476, I1434, -1, -1, -1);
                    }
                }
                fScalarIsForced = 0;
                fScalarIsReleased = 0;
            }
        }
    }
    {
        {
            U  ** I1538 = (U  **)(pcode + 8);
            {
                U  ** I1541 = (U  **)(pcode + 16);
                if (!(((UP )(*I1541)) & 1) || !(((UP )(*I1538)) & 1)) {
                    hsimDispatchCbkMemOptDynElabS(I1538, I1541, val, fScalarIsForced, fScalarIsReleased, 0U);
                }
            }
        }
    }
    {
        RmaNbaGate1  * I1448 = (RmaNbaGate1  *)(pcode + 24);
        U  I1449 = (((I1448->I5) >> (16)) & ((1 << (1)) - 1));
        scalar  I1076 = X4val[val];
        if (I1449) {
            I1448->I1082.I855 = (void *)((RP )(((RP )(I1448->I1082.I855) & ~0x3)) | (I1076));
        }
        else {
            I1448->I1082.I856.I831 = I1076;
        }
        NBA_Semiler(0, &I1448->I1082);
    }
}
void  hs_0_M_33_0__simv_daidir (UB  * pcode, scalar  val)
{
    UB  * I1679;
    *(pcode + 0) = val;
    if (*(pcode + 1)) {
        return  ;
    }
    hs_0_M_33_21__simv_daidir(pcode, val);
    fScalarIsReleased = 0;
}
void  hs_0_M_33_1__simv_daidir (UB  * pcode, scalar  val, U  I701, scalar  * I1367, U  did)
{
    U  I1346 = 0;
    *(pcode + 1) = 1;
    fScalarIsForced = 1;
    hs_0_M_33_21__simv_daidir(pcode, val);
    fScalarIsForced = 0;
}
void  hs_0_M_33_2__simv_daidir (UB  * pcode)
{
    scalar  val;
    fScalarIsReleased = 1;
    val = *(pcode + 0);
    *(pcode + 1) = 0;
    hs_0_M_33_21__simv_daidir(pcode, val);
    fScalarIsReleased = 0;
}
void  hs_0_M_33_11__simv_daidir (UB  * pcode, scalar  val)
{
    *(pcode + 0) = val;
    if (*(pcode + 1)) {
        return  ;
    }
    hs_0_M_33_21__simv_daidir(pcode, val);
    fScalarIsReleased = 0;
}
#ifdef __cplusplus
extern "C" {
#endif
void SinitHsimPats(void);
#ifdef __cplusplus
}
#endif
