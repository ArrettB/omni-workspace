/*
 * Dynamic Information Systems, LLC
 *
 * This software can only be used with the expressed written consent of Dynamic
 * Information Systems. All rights reserved.
 *
 * Copyright 2005, Dynamic Information Systems, LLC $Id:
 * AbstractMenuRenderer.java 131 2005-07-13 18:48:34Z $
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 * FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL DYNAMIC
 * INFORMATIONS SYTEMS, LLC BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * ====================================================================
 */


package com.dynamic.charm.web.tag.menu;

import java.util.Locale;

import javax.servlet.ServletRequest;
import javax.servlet.jsp.PageContext;

import org.apache.log4j.Logger;
import org.springframework.context.NoSuchMessageException;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.support.RequestContext;

import com.dynamic.charm.web.builder.AnchorElement;
import com.dynamic.charm.web.builder.HTMLElement;
import com.dynamic.charm.web.builder.HrefBuilder;


public abstract class AbstractMenuRenderer implements MenuRenderer
{
    private final static Logger logger = Logger.getLogger(AbstractMenuRenderer.class);
    protected String contextPath;
    protected Locale locale;
    protected RequestContext requestContext;
    protected PageContext pageContext;
    protected MenuItem[] menuItems;
    protected String menuTitle;
    protected String menuTitleHref;
    private String[] stickyParams;

    public void setMenuTitle(String menuTitle)
    {
        this.menuTitle = menuTitle;
    }

    public void setMenuTitleHref(String menuTitleHref)
    {
        this.menuTitleHref = menuTitleHref;
    }

    public final void setContextPath(String contextPath)
    {
        this.contextPath = contextPath;
    }

    public final void setLocale(Locale locale)
    {
        this.locale = locale;
    }

    public final void setRequestContext(RequestContext context)
    {
        this.requestContext = context;
    }

    public final void setPageContext(PageContext context)
    {
        this.pageContext = context;
    }

    public final void setMenuItems(MenuItem[] items)
    {
        this.menuItems = items;
    }

    public void setStickyParameters(String[] stickyParams)
    {
        this.stickyParams = stickyParams;
    }

    public abstract String render();

    public HTMLElement createAnchorElement(MenuItem item, HTMLElement root)
    {
        String href = item.getHref();
        if (href == null)
        {
        	href = "";
        }
        HrefBuilder builder = new HrefBuilder(href, contextPath);

        ServletRequest request = pageContext.getRequest();

        // copy values for any sticky parameters we have
        if (stickyParams != null)
        {
            for (int i = 0; i < stickyParams.length; i++)
            {
                String paramValue = request.getParameter(stickyParams[i]);
                if (StringUtils.hasText(paramValue))
                {
                    builder.addParameter(stickyParams[i], paramValue);
                }
            }
        }

        // add parameter for the menu code
        builder.addParameter(MenuRenderer.SELECTED_MENU_ITEM_ATTR, item.getCode());

        String display = getMessage(item.getDisplay(), item.getDisplay());
        AnchorElement result = root.createAnchorElement(display, builder);
        result.setAttribute("target", item.getTarget());

        return result;
    }

    public String getMessage(String messageKey, String defaultMessage)
    {
        String result = null;
        try
        {
            result = requestContext.getWebApplicationContext().getMessage(messageKey, null, locale);
        }
        catch (NoSuchMessageException ignored)
        {
            result = defaultMessage;
        }
        return result;
    }
}
