package com.dynamic.servicetrax.service;

import org.apache.log4j.Logger;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;

/**
 * User: pgarvie
 * Date: Apr 25, 2011
 * Time: 5:04:33 PM
 */
public class EmailService {

    public static final Logger LOGGER = Logger.getLogger(EmailService.class);

    private JavaMailSender mailSender;
    private String fromEmail;
    private String subject;

    public Boolean send(String to, String text) {

        try {
            LOGGER.info("Properties: " + ((JavaMailSenderImpl) mailSender).getSession().getProperties());
            SimpleMailMessage theMessage = new SimpleMailMessage();
            theMessage.setTo(to);
            theMessage.setText(text);
            theMessage.setFrom(fromEmail);
            theMessage.setSubject(subject);
            mailSender.send(theMessage);
            return Boolean.TRUE;
        }
        catch (MailException e) {
            LOGGER.error(e);
        }
        return Boolean.FALSE;
    }

    public void setMailSender(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    public void setFromEmail(String fromEmail) {
        this.fromEmail = fromEmail;
    }

    public String getFromEmail() {
        return fromEmail;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }
}
