/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: Money.java 199 2006-11-14 23:38:41Z gcase $

* THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
* OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED.  IN NO EVENT SHALL DYNAMIC INFORMATIONS SYTEMS, LLC
* BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
* SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
* LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
* USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
* OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
* SUCH DAMAGE.
* ====================================================================
*/


package com.dynamic.charm.types;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.ParseException;


/**
 * @author gcase
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class Money implements Comparable
{
    public final static int ROUND_DOWN = BigDecimal.ROUND_DOWN;
    public final static int ROUND_HALF_UP = BigDecimal.ROUND_HALF_UP;
    public final static int ROUND_UP = BigDecimal.ROUND_UP;

    private BigDecimal _value;
    private int roundingMethod = ROUND_DOWN;
    private String currencyFormat = null;

    public Money()
    {
        _value = new BigDecimal(0);
    }

    public Money(double value)
    {
        _value = new BigDecimal(value);
    }

    public Money(long value)
    {
        _value = new BigDecimal(value);
    }

    public Money(long value, int scale)
    {
        _value = new BigDecimal(value);
    }

    public Money(String value) throws ParseException
    {
        _value = new BigDecimal(createFormatter().parse(value).doubleValue());
    }

    public Money(BigDecimal value)
    {
        _value = value;
    }

    public Money(Money value)
    {
        _value = new BigDecimal(value.doubleValue());
    }

    public Money add(Money value)
    {
        return new Money(_value.add(value._value));
    }

    public Money subtract(Money value)
    {
        return new Money(_value.add(value._value));
    }

    public Money multiply(double value)
    {
        return new Money(_value.multiply(new BigDecimal(value)));
    }

    public Money multiply(long value)
    {
        return new Money(_value.multiply(new BigDecimal(value)));
    }

    public Money divide(double value)
    {
        return new Money(_value.divide(new BigDecimal(value), roundingMethod));
    }

    public Money divide(long value)
    {
        return new Money(_value.divide(new BigDecimal(value), roundingMethod));
    }

    public Money negate()
    {
        return new Money(_value.negate());
    }

    public Money abs()
    {
        return new Money(_value.abs());
    }

    public boolean isZero()
    {
        return _value.doubleValue() == 0;
    }

    public boolean IsPositive()
    {
        return _value.doubleValue() > 0;
    }

    public boolean IsNegative()
    {
        return _value.doubleValue() < 0;
    }

    public boolean isEqual(Money value)
    {
        return _value.equals(value._value);
    }

    public boolean isLessThan(Money value)
    {
        return compareTo(value) < 0;
    }

    public boolean isLessThanOrEqual(Money value)
    {
        return compareTo(value) <= 0;
    }

    public boolean isGreaterThan(Money value)
    {
        return compareTo(value) > 0;
    }

    public boolean isGreaterThanOrEqual(Money value)
    {
        return compareTo(value) >= 0;
    }

    public int compareTo(Object o)
    {
        return compareTo((Money) o);
    }

    public int compareTo(Money m)
    {
        return _value.compareTo(m._value);
    }

    public double doubleValue()
    {
        return _value.doubleValue();
    }

    public String toString()
    {
        return createFormatter().format(doubleValue());
    }

    private NumberFormat createFormatter()
    {
        if (currencyFormat == null)
        {
            return NumberFormat.getCurrencyInstance();
        }
        else
        {
            return new DecimalFormat(currencyFormat);
        }
    }

    public static Money parse(String value) throws ParseException
    {
        return new Money(NumberFormat.getCurrencyInstance().parse(value).doubleValue());
    }

    public String getCurrencyFormat()
    {
        return currencyFormat;
    }

    public void setCurrencyFormat(String currencyFormat)
    {
        this.currencyFormat = currencyFormat;
    }

    public int getRoundingMethod()
    {
        return roundingMethod;
    }

    public void setRoundingMethod(int roundingMethod)
    {
        if ((roundingMethod == ROUND_DOWN) || (roundingMethod == ROUND_UP) || (roundingMethod == ROUND_HALF_UP))
        {
            this.roundingMethod = roundingMethod;
        }
        else
        {
            throw new IllegalArgumentException();
        }
    }

    public static void main(String[] args)
    {
        //            float f = 9.48f;
        //            System.out.println(f * 100);

        NumberFormat nf = NumberFormat.getCurrencyInstance();
        for (int i = 0; i < 1000000; i++)
        {
            float num = (float) (.01 * i);
            Money money = new Money(num);
            Money moneyMult1 = money.multiply(100);
            Money moneyMult2 = new Money(num * 100);

            String s1 = moneyMult1.toString();
            String s2 = moneyMult2.toString();

            //
            //              if (!moneyMult1.isEqual(moneyMult2))
            //              {
            //                  System.out.println(money + "* 100 = " +   moneyMult1 + " != " + moneyMult2.);
            //              }
            //
            if (!s1.equals(s2))
            {
                System.out.println("(" + money + " * 100)" + s1 + " != " + s2);
            }
        }
    }
}
