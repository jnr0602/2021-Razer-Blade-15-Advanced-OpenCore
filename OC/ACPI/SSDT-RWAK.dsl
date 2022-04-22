/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200925 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLR6A9lu.aml, Thu Apr 21 23:21:42 2022
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000218 (536)
 *     Revision         0x02
 *     Checksum         0xE9
 *     OEM ID           "CORP"
 *     OEM Table ID     "RWAK"
 *     OEM Revision     0x00001000 (4096)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200925 (538970405)
 */
DefinitionBlock ("", "SSDT", 2, "CORP", "RWAK", 0x00001000)
{
    External (_SB.IETM, UnknownObj)
    External (_SB.PCI0.GFX0.CLID, UnknownObj)
    External (_SB.PCI0.LPCB.EC0.LID0, DeviceObj)
    External (_SB.PCI0.LPCB.EC0.PSTA, UnknownObj)
    External (_SB.PCI0.LPCB.EC0.SCPS, UnknownObj)
    External (_SB.PWRB, UnknownObj)
    External (_SB.PWRB.PBST, UnknownObj)
    External (DPTF, UnknownObj)
    External (IGDS, UnknownObj)
    External (LIDS, UnknownObj)
    External (PBSS, UnknownObj)
    External (_SB.PCI0.LPCB.EC0, DeviceObj)
    External (_SB.PCI0.LPCB.EC0.RTEC, MethodObj)
    External (ECON, UnknownObj)
    External (ECN0, UnknownObj)
    External (DBG8, UnknownObj)

    Method (RWAK, 1, Serialized)
    {
        If (((Arg0 == 0x03) || (Arg0 == 0x04)))
        {
            If ((\_SB.PWRB.PBST == One))
            {
                If (PBSS)
                {
                    Notify (\_SB.PWRB, 0x02) // Device Wake
                    PBSS = One
                }
            }

            If (CondRefOf (\_SB.PCI0.AWMI.WMAA))
            {
                \_SB.PCI0.LPCB.EC0.SCPS |= 0x40 /* External reference */
            }

            If ((DPTF == One))
            {
                Notify (\_SB.IETM, 0x08) // Capabilities Check
                Notify (\_SB.IETM, 0xA0) // Device-Specific
                Notify (\_SB.IETM, One) // Device Check
            }

            Local0 = (\_SB.PCI0.LPCB.EC0.PSTA & 0x04)
            If (_OSI ("Darwin"))
            {
                LIDS = One
            }
            Else
            {
                LIDS = Zero
            }

            If (Local0)
            {
                LIDS = One
            }

            If (IGDS)
            {
                If ((LIDS == One))
                {
                    \_SB.PCI0.GFX0.CLID = 0x03
                }
                Else
                {
                    \_SB.PCI0.GFX0.CLID = Zero
                }
            }

            Notify (\_SB.PCI0.LPCB.EC0.LID0, 0x80) // Status Change
        }
    }

    Scope (\_SB.PCI0.LPCB.EC0)
    {
        Method (_REG, 2, NotSerialized)  // _REG: Region Availability
        {
            If (((Arg0 == 0x03) && (Arg1 == One)))
            {
                ECON = One
                ECN0 = One
                RTEC ()
                Local0 = (PSTA & 0x04)
                If (_OSI ("Darwin"))
                {
                    LIDS = One
                }
                Else
                {
                    LIDS = Zero
                }
                If (Local0)
                {
                    LIDS = One
                }

                If (IGDS)
                {
                    If ((LIDS == One))
                    {
                        ^^^GFX0.CLID = 0x03
                    }
                    Else
                    {
                        ^^^GFX0.CLID = Zero
                    }
                }
            }
        }
        Method (_Q14, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            DBG8 = 0x14
            Local0 = (PSTA & 0x04)
            If (_OSI ("Darwin"))
                {
                    LIDS = One
                }
                Else
            {
                LIDS = Zero
            }
            If (Local0)
            {
                LIDS = One
            }

            If (IGDS)
            {
                If ((LIDS == One))
                {
                    ^^^GFX0.CLID = 0x03
                }
                Else
                {
                    ^^^GFX0.CLID = Zero
                }
            }

            Notify (LID0, 0x80) // Status Change
        }
    }
}

