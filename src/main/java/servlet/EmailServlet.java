package servlet;

import Email.GmailSender;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Email.EmailData;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/send-email")
public class EmailServlet extends HttpServlet {

    private final String GMAIL_USERNAME = "manhttth04996@gmail.com";
    private final String GMAIL_APP_PASSWORD = "oxzv hlia biae ggmu";

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            GmailSender.init(GMAIL_USERNAME, GMAIL_APP_PASSWORD, false);
        } catch (IllegalStateException e) {
        } catch (Exception e) {
            System.err.println("Lỗi khởi tạo GmailSender: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        request.setAttribute("senderEmail", GMAIL_USERNAME);
        request.setAttribute("pageTitle", "Gửi Email");
        request.getRequestDispatcher("/WEB-INF/views/send-email.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String toRecipientsStr = request.getParameter("toRecipients");
        String subject = request.getParameter("subject");
        String content = request.getParameter("content");

        try {
            List<String> toList = parseRecipients(toRecipientsStr);

            EmailData email = new EmailData(toList, subject, content);
            email.setHtml(true);

            GmailSender.getInstance().send(email);

        } catch (Exception e) {
            System.err.println("LỖI GỬI EMAIL: " + e.getMessage());
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/thuoc");
    }

    private List<String> parseRecipients(String recipientsStr) {
        if (recipientsStr == null || recipientsStr.trim().isEmpty()) {
            return new ArrayList<>();
        }
        return Arrays.stream(recipientsStr.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .collect(Collectors.toList());
    }
}