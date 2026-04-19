<%@ page contentType="text/html;charset=UTF-8" language="java" %>
</div> </div> </div> <style>
    .app-footer {
        background-color: #333;
        color: white;
        padding: 15px;
        text-align: center;
        font-size: 0.9rem;
    }
</style>

<footer class="app-footer">
    ( ﾉ ﾟｰﾟ)ﾉ  Hệ thống quản lý được thực hiện bởi Trương Thế Mạnh - TH04996.
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const sidebar = document.getElementById('sidebar');
        const toggleBtn = document.getElementById('sidebarToggle');

        // Kiểm tra trạng thái đã lưu trong trình duyệt
        const isCollapsed = localStorage.getItem('sidebarCollapsed') === 'true';
        if (isCollapsed) {
            sidebar.classList.add('collapsed');
        }

        toggleBtn.addEventListener('click', function() {
            sidebar.classList.toggle('collapsed');
            // Lưu trạng thái vào localStorage
            localStorage.setItem('sidebarCollapsed', sidebar.classList.contains('collapsed'));
        });
    });
</script>

</body>
</html>