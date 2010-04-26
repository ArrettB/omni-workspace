/*
*               Dynamic Information Systems, LLC
*
* This software can only be used with the expressed written
* consent of Dynamic Information Systems. All rights reserved.

* Copyright 2005, Dynamic Information Systems, LLC
* $Id: UrlFilenameViewController.java 199 2006-11-14 23:38:41Z gcase $

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


package com.dynamic.charm.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;


/**
 * Acts similiarly to the org.springframework.web.servlet.mvc.UrlFilenameViewController, except it does
 * not remove the path information after the context.
 * @author gcase
 *
 */
public class UrlFilenameViewController implements Controller
{
    private final static Logger logger = Logger.getLogger(UrlFilenameViewController.class);

    public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response)
    {
        logger.debug("handleRequest()");

        String uri = request.getRequestURI();
        String pathInfo = request.getPathInfo();
        String context = request.getContextPath();

        logger.debug("uri = " + uri);
        logger.debug("pathInfo = " + pathInfo);
        logger.debug("context = " + context);

        //remove the context
        int begin = context.length() + 1;

        /*
                        int begin = uri.lastIndexOf('/');
                        if (begin == -1)
                        {
                                begin = 0;
                        } else
                        {
                                begin++;
                        }
        */
        int end;
        if (uri.indexOf(";") != -1)
        {
            end = uri.indexOf(";");
        }
        else if (uri.indexOf("?") != -1)
        {
            end = uri.indexOf("?");
        }
        else
        {
            end = uri.length();
        }

        String fileName = uri.substring(begin, end);
        if (fileName.indexOf(".") != -1)
        {
            fileName = fileName.substring(0, fileName.lastIndexOf("."));
        }
        return new ModelAndView(fileName);
    }
}
