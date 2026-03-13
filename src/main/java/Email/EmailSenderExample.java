package Email;
import java.io.File;
import java.util.Arrays;
import java.util.List;
public class EmailSenderExample {
    public static void main(String[] args) {
        String username = "palsđàád@gmail.com";
        String appPassword = "oxzv hlia biae ggmu";
        GmailSender sender = GmailSender.init(username, appPassword, true);
        List<String> recipients = Arrays.asList("manhttth04996@gmail.com", "trthemanh2k8@gmail.com");
        EmailData email = new EmailData(
                recipients,
                "Test Email từ Ứng dụng của bạn",
                "Đây là email thử nghiệm với file đính kèm."
        );
        email.setHtml(false)
                .setCc(Arrays.asList("trthemanh2k8@gmail.com"))
                .setBcc(Arrays.asList("trthemanh2k8@gmail.com"));
        File attachment = new File("path/to/your/attachment.pdf");
        if(attachment.exists()) {
            email.setAttachments(Arrays.asList(attachment));
        }
        sender.send(email);
        System.out.println("Email đang được gửi...");
    }
}