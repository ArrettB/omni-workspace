/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: PasswordPropertyEditor.java 199 2006-11-14 23:38:41Z gcase $

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


package com.dynamic.charm.web.form.tag.editor;

import java.beans.PropertyEditorSupport;

import org.apache.log4j.Logger;

import com.dynamic.charm.security.Password;


public class PasswordPropertyEditor extends PropertyEditorSupport
{
    private final static Logger logger = Logger.getLogger(PasswordPropertyEditor.class);

    private String oldPassword;
    private String useOriginalKey;
    private Password password;
    
    public PasswordPropertyEditor(String oldPassword, String useOriginalKey)
    {
        this(oldPassword, useOriginalKey, null);
    }

    public PasswordPropertyEditor(String oldPassword, String useOriginalKey, Password password)
    {
        this.oldPassword = oldPassword;
        this.useOriginalKey = useOriginalKey;
        this.password = password;
    }

    public void setAsText(String newPassword) throws IllegalArgumentException
    {
        logger.debug("setAsText()");
        if (useOriginalKey.equals(newPassword))
        {
            super.setValue(oldPassword);
        }
        else if (password != null)
        {
        	password.setPassword(newPassword);
            super.setValue(password.computeSaltedHash());
        }
        else
        {
            super.setValue(newPassword);
        }
    }

    public String getAsText()
    {
        logger.debug("getAsText()");

        Object value = getValue();
        return value.toString();
    }
}
