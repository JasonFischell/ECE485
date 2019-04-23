U = [1 1; 2 1; 4 1; 5 1; 7 1];
y = [3;3;-1;-5;-8];

B = ((U'*U)^-1)*U'*y;

figure
x_hat = 1:7;
y_hat = B(1).*x_hat + B(2);
plot(x_hat, y_hat, 'k-')
hold on
plot([1 2 4 5 7], y', 'k*')
axis([.9 7.1 -9 5])
title('Least Squares Regression Warm-Up')
legend('Least Squares Regression', 'Original Data')
