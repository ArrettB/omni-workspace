/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: PasswordTag.java 199 2006-11-14 23:38:41Z gcase $

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


package com.dynamic.charm.web.form.tag;

import javax.servlet.jsp.JspException;

import org.acegisecurity.providers.dao.DaoAuthenticationProvider;
import org.acegisecurity.providers.encoding.PasswordEncoder;
import org.apache.log4j.Logger;

import com.dynamic.charm.security.Password;
import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.builder.InputElement;
import com.dynamic.charm.web.form.tag.editor.PasswordPropertyEditor;
import com.dynamic.charm.web.tag.support.EvalTool;


/**
 *
 *
 * Attributes:
 * <table border="1" cellpadding="3" cellspacing="0" width="100%">
 * <tbody>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>encrypt</b></td>
 * <td>Boolean attribute that determines if the value returned by this tag should be encrypted.  
 * If set to true, it will look for the value of the <code>com.dynamic.charm.web.form.tag.PasswordTag.encoder</code>
 * property, attempt to find a bean defined by that name, and use it to encode the passsword.  The class must implement 
 * the <code>org.acegisecurity.providers.encoding.PasswordEncoder</code> interface
 * </td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>salt</b></td>
 * <td>The value of the salt that should be used when encoding the password</td>
 * </tr>
 * </tbody>
 * </table>
 *
 * <br><br>
 * Attributes Inherited From BaseTag:
 * <table border="1" cellpadding="3" cellspacing="0" width="100%">
 * <tbody>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>css</b></td>
 * <td>The value that will be used for the class attribute on the generated tag</td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>style</b></td>
 * <td>Pass through attribute for style</td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>id</b></td>
 * <td>Pass through attribute for id</td>
 * </tr>
 * </tbody>
 * </table>
 * <br><br>
 * 
 * Attributes Inherited From AbstractFieldTag:
 * <table border="1" cellpadding="3" cellspacing="0" width="100%">
 * <tbody>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>bind</b></td>
 * <td>The object that this tag will be used to edit</td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>property</b></td>
 * <td>The name of the property that this tag will be bound to</td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>decorator</b></td>
 * <td>The name of the decorator that should be used to decorate the tags.  The name given here must be defined in Spring ApplicationContext</td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>label</b></td>
 * <td></td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>labeltooltip</b></td>
 * <td></td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>tooltip</b></td>
 * <td></td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>defaultValue</b></td>
 * <td></td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>value</b></td>
 * <td></td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>mandatory</b></td>
 * <td></td>
 * </tr>
 * <tr>
 * <td bgcolor="#e8e8e8" width="20%"><b>readonly</b></td>
 * <td></td>
 * </tr>
 * <tr>
 * </tr>
 * </tbody> 
 * </table>
 * <br><br>
 * 
 * 
 * @author gcase
 * @jsp.tag name="password" body-content="empty" dynamic-attributes="true"
 */
public class PasswordTag extends AbstractFieldTag
{
    private final static Logger logger = Logger.getLogger(PasswordTag.class);

    private final static String USE_ORGINAL = "~~!!!!~~";
 
    private boolean encrypt;
    private String encryptExpr;
    private Object salt;
    
 	protected void evaluateExpresssions(EvalTool evalTool) throws JspException
    {
        super.evaluateExpresssions(evalTool);
        encrypt = evalTool.evaluateAsBoolean("encrypt", encryptExpr, false);
    }

    public void render(HTMLElement formElement)
    {
        logger.debug("render()");

        //only display the password value if it is hardcoded in the tag
        String formMode = (String) pageContext.getAttribute(FormTag.ATTRIBUTE_MODE);
        String valueToDisplay = value;
        if (FormTag.MODE_UPDATE.equals(formMode))
        {
            if (valueToDisplay == null)
            {
                valueToDisplay = USE_ORGINAL;
            }
        }
 
        InputElement input = formElement.createInputElement("password", getControlName(), valueToDisplay);
        input.setAttribute("id", getControlName());
        applyCommonAttributes(input);

        //bind the editor
        if (encrypt)
        {
        	Password passwordObj = createPassword();
        	passwordObj.setSalt(salt.toString());
  			bindPropertyEditor(new PasswordPropertyEditor(getBoundValueAsString(), USE_ORGINAL, passwordObj));          
        }
        else
        {
            bindPropertyEditor(new PasswordPropertyEditor(getBoundValueAsString(), USE_ORGINAL));
        }
    }

    
	/**
	 * This method is responsbile for creating a new PasswordObject with the correct encoding.  This should
	 * be the same encoding that acegi uses to do authentication.  This implementation simply asks spring for the 
	 * Pasword bean, which should be sent to singleton=false so we get a new object each time this is called.
	 * 
	 * @return the configured Password object
	 * @see Password
	 * @see PasswordEncoder
	 * @see DaoAuthenticationProvider
	 */
	protected Password createPassword()
	{
		String beanName = getPrefixedMessage(PasswordTag.class, "password");
		return (Password) getBean(Password.DEFAULT_BEAN_NAME);
	}
	
    
    /**
     * Getter for property encrypt.
     *
     * @return Value of property encrypt
     * @jsp.attribute required="false" rtexprvalue="true" type="boolean"
     *                description="If true, it will encrypt the value before storing in the bound object"
     */
    public String getEncrypt()
    {
        return encryptExpr;
    }

    public void setEncrypt(String encrypt)
    {
        this.encryptExpr = encrypt;
    }
    
    /**
	 * Getter for property encrypt.
	 * 
	 * @return Value of the salt to used when encoding the password
	 * @jsp.attribute required="false" rtexprvalue="true"
	 *                description="The salt value that should be appended to the password before encrypting"
	 */
	public Object getSalt()
	{
		return salt;
	}

	public void setSalt(Object salt) throws JspException
	{
		if (salt == null)
		{
			this.salt = null;
		}
		else if (salt instanceof String)
		{
			// must be an expression
			EvalTool evalTool = new EvalTool(this, pageContext);
			this.salt = evalTool.evaluateAsObject("salt", (String) salt);
		}
		else
		{
			this.salt = salt;
		}

	}

}
