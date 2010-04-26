/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: Field.java 199 2006-11-14 23:38:41Z gcase $

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


package com.dynamic.charm.web.form;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;


public class Field
{
    public final static int MANDATORY_YES = 1;
    public final static int MANDATORY_NO = 2;
    public final static int MANDATORY_UNKNOWN = 3;
    private String bindName;
    private String property;
    private boolean displayOnly;
    private int mandatoryStatus = MANDATORY_UNKNOWN;

    public Field(String bindName, String property)
    {
        this.bindName = bindName;
        this.property = property;
    }

    public String getBindName()
    {
        return bindName;
    }

    public void setBindName(String bindName)
    {
        this.bindName = bindName;
    }

    public String getProperty()
    {
        return property;
    }

    public void setProperty(String property)
    {
        this.property = property;
    }

    public int getMandatoryStatus()
    {
        return mandatoryStatus;
    }

    public void setMandatoryStatus(int mandatoryStatus)
    {
        this.mandatoryStatus = mandatoryStatus;
    }

    public boolean isMandatory()
    {
        return mandatoryStatus == MANDATORY_YES;
    }

    public void setMandatory(boolean mandatory)
    {
        mandatoryStatus = mandatory ? MANDATORY_YES : MANDATORY_NO;
    }

    public boolean isDisplayOnly()
    {
        return displayOnly;
    }

    public void setDisplayOnly(boolean displayOnly)
    {
        this.displayOnly = displayOnly;
    }

    public String toString()
    {
        return "Field: " + bindName + "." + property + " (displayOnly = " + isDisplayOnly() + ", mandatory = " + isMandatory() + ")";
    }

    public boolean equals(Object o)
    {
        if (!(o instanceof Field))
        {
            return false;
        }

        Field rhs = (Field) o;
        return new EqualsBuilder().appendSuper(super.equals(o)).append(bindName, rhs.bindName).append(property, rhs.property).isEquals();
    }

    public int hashCode()
    {
        return new HashCodeBuilder(17, 37).append(bindName).append(property).toHashCode();
    }
}
