/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: BoundProperty.java 199 2006-11-14 23:38:41Z gcase $

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

public class BoundProperty
{
    private String propertyName;
    private String bindName;
    private boolean valid;

    public BoundProperty(String bindName, String propertyName)
    {
        this.bindName = bindName;
        this.propertyName = propertyName;
    }

    public BoundProperty(String boundPropertyKey)
    {
        int pos = boundPropertyKey.indexOf("_");
        if (pos >= 0)
        {
            this.bindName = boundPropertyKey.substring(0, pos);
            this.propertyName = boundPropertyKey.substring(pos + 1);
            this.valid = true;
        }
        else
        {
            this.valid = false;
        }
    }

    public String getBoundPropertyKey()
    {
        return bindName + "_" + propertyName;
    }

    public String getBindName()
    {
        return bindName;
    }

    public void setBindName(String bindName)
    {
        this.bindName = bindName;
    }

    public String getPropertyName()
    {
        return propertyName;
    }

    public void setPropertyName(String propertyName)
    {
        this.propertyName = propertyName;
    }

    public boolean isValid()
    {
        return valid;
    }

    public void setValid(boolean boundProperty)
    {
        this.valid = boundProperty;
    }
}
