/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: AuditTag.java 199 2006-11-14 23:38:41Z gcase $

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


package com.dynamic.charm.web.form.tag.audit;

import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.tagext.Tag;

import org.apache.log4j.Logger;
import org.apache.taglibs.standard.resources.Resources;

import com.dynamic.charm.web.form.tag.BaseTag;
import com.dynamic.charm.web.form.tag.FieldParent;


/**
 * JSP Tag Handler class
 *
 * @jsp.tag name = "audit" body-content="empty" display-name = "Audit" description =
 *          "Displays audit information for a particular bound object"
 */
public class AuditTag extends BaseTag
{
    private final static Logger logger = Logger.getLogger(AuditTag.class);
    private String bind;
    protected FieldParent parent;

    protected int doStartTagInternal() throws Exception
    {
        logger.debug("doStartTagInternal()");

        Tag t = findAncestorWithClass(this, FieldParent.class);
        if (t == null)
        {
            throw new JspTagException(Resources.getMessage("com.dynamic.charm.form.field_outside_parent"));
        }

        // send the parameter to the appropriate ancestor
        parent = (FieldParent) t;

        Object bound = parent.getFormModel().getBoundObject(bind);
        if (bound == null)
        {
            //todo figure out best way to handle this
            write("<!-- Could not find an object bound with the name " + bind + "-->");
        }
        else
        {
            
            AuditInfo info = (AuditInfo) getBean(AuditInfo.DEFAULT_BEAN_NAME, AuditInfo.class);
            info.setAuditedObject(bound);
            
            String renderer = getPrefixedMessage(AuditTag.class, "renderer");
            Class rendererClass = Class.forName(renderer);
            AuditInfoRenderer rendererInstance = (AuditInfoRenderer) rendererClass.newInstance();
            rendererInstance.setPageContext(pageContext);

            write(rendererInstance.render(info));
        }

        return EVAL_BODY_INCLUDE;
    }

    /**
     * Getter for property bind.
     *
     * @return Value of property bind.
     * @jsp.attribute required="true" rtexprvalue="true" description="The bind
     *                name to get errors for"
     */
    public String getBind()
    {
        return bind;
    }

    public void setBind(String bind)
    {
        this.bind = bind;
    }
}
