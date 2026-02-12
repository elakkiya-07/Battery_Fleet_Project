INTERNAL RESISTANCE GRAPH INTERPRETATION:
X-axis: Cycle Number
Y-axis: Normalized Internal Resistance
FROM THE GRAPHS:
**All three batteries show progressive resistance growth.
**The growth accelerates in later cycles, indicating aging acceleration.
**B7 exhibits the highest final resistance, indicating more severe degradation compared to B5 and B6.

HOW INTERNAL RESISTANCE WAS NORMALIZED:
The internal resistance for each cycle was normalized using the first-cycle resistance as the baseline:
**Rnorm​(n) = R(n)/R(1)
This ensures:
1.The first value equals 1
2.All subsequent values represent relative growth
3.The curve shows how many times the resistance has increased compared to its initial value
 For example, if resistance doubles, the normalized value becomes 2.

FUNCTION USED:
R0 = R_internal(1);
R_norm = R_internal / R0;
R_smooth = movmean(R_internal, k);
R_norm = R_smooth / R_smooth(1);

HOW THIS NORMALIZATION WAS VERIFIED:
Normalization was validated by:
Checking that the first normalized value equals 1
Confirming that:
            **Rnorm​(final)=R(final)/R(initial)
Ensuring the curve shape remains unchanged (only scaled vertically)

CAPACITY FADE GRAPH INTERPRETATION:
HOW CAPACITY WAS NORMALIZED:
Battery capacity per cycle (BCt) was normalized using the initial cycle capacity as the reference:
          **SoH(n)=C(n)/C(1)
This ensures:
1.The first value equals 1
2.The curve directly represents State of Health (SOH)
3.Degradation is shown as a relative decline
Capacity Fade (%) was then computed as: 
        **Fade%=(1−SOH)×100
VERIFICATION:
If:
Initial capacity = 1.98 Ah
Final capacity = 0.90 Ah
          **𝑆𝑂𝐻=0.90/1.98≈0.45
The graph ends near 45% SOH and 55% fade — confirming correct normalization.

HARDWARE IMPLEMENTATION:
Hardware implementation will measure:
  I.ADC_voltage
  II.ADC_current
  III.ADC_temperature
The firmware will reproduce:
  I.R_internal
  II.BCt
  III.SOH



