/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: DefaultAuditInfoRenderer.java 199 2006-11-14 23:38:41Z gcase $

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

import java.util.Date;

import javax.servlet.jsp.PageContext;

import org.apache.commons.lang.time.FastDateFormat;
import org.springframework.util.StringUtils;

import com.dynamic.charm.web.builder.HTMLElement;


public class DefaultAuditInfoRenderer implements AuditInfoRenderer
{
    private String auditInfoCss = "auditInfo";
    private String auditItemCss = "auditItem";
    private PageContext pageContext;

    public String render(AuditInfo info)
    {
        HTMLElement root = HTMLElement.createRootElement();
        HTMLElement div = root.createElement("div");
        div.css(auditInfoCss);

        //      if (FormTag.MODE_UPDATE.equals(pageContext.getAttribute(FormTag.ATTRIBUTE_MODE)))
        //        {
        if (info.getCreatedByName() != null)
        {
            createInfoItem("Created By", div, info.getCreatedByName(), info.getCreatedByEmail(), info.getDateCreated());
        }
        else
        {
            createSimpleInfoItem("This record has not yet been created.", div);
        }
        if (info.getModifiedName() != null)
        {
            createInfoItem("Modified By", div, info.getModifiedName(), info.getModifiedEmail(), info.getDateModified());
        }
        else
        {
            createSimpleInfoItem("This record has not yet been modified.", div);
        }

        //        }
        //        else
        //        {
        //               createSimpleInfoItem("Audit information is not available.", div);
        //        }

        return div.evaluate();
    }

    private HTMLElement createSimpleInfoItem(String text, HTMLElement parentElement)
    {
        HTMLElement result = parentElement.createElement("div");
        result.css(auditItemCss);
        result.setText(text);
        return result;
    }

    private HTMLElement createInfoItem(String prefix, HTMLElement parentElement, String name,
        String email, Date date)
    {
        FastDateFormat formatter = FastDateFormat.getInstance("MM/dd/yyy hh:mm a");
        String dateString = null;
        if (date != null)
        {
            dateString = formatter.format(date);
        }

        HTMLElement result = parentElement.createElement("div");
        result.css(auditItemCss);

        if (!StringUtils.hasText(email))
        {
            result.addText(prefix + " " + name);
            if (dateString != null)
            {
                result.addSpace();
                result.addText("at " + dateString);
            }
            result.addText(".");
        }
        else
        {
            String mailTo = "mailto:" + email;
            result.addText(prefix);
            result.addSpace();
            result.createAnchorElement(name, mailTo);
            if (dateString != null)
            {
                result.addSpace();
                result.addText("at " + dateString);
            }
            result.addText(".");
        }
        return result;
    }

    public void setPageContext(PageContext pageContext)
    {
        this.pageContext = pageContext;
    }
}
