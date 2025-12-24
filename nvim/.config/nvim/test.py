# debug_test.py
def factorial(n):
    """计算阶乘的递归函数"""
    if n <= 1:
        return 1
    else:
        return n * factorial(n - 1)


def fibonacci(n):
    """计算斐波那契数列"""
    if n <= 0:
        return 0
    elif n == 1:
        return 1
    else:
        a, b = 0, 1
        for _ in range(2, n + 1):
            c = a + b
            a, b = b, c
        return b


def process_data(data_list):
    """处理数据列表的函数"""
    result = []
    for i, item in enumerate(data_list):
        # 这里可以设置断点来观察循环过程
        processed_item = item * 2 + i
        result.append(processed_item)
    return result


def main():
    print("开始调试测试程序...")

    # 测试阶乘函数
    num = 5
    fact_result = factorial(num)
    print(f"{num}的阶乘是: {fact_result}")

    # 测试斐波那契数列
    fib_num = 10
    fib_result = fibonacci(fib_num)
    print(f"斐波那契数列第{fib_num}项是: {fib_result}")

    # 测试数据处理
    data = [1, 2, 3, 4, 5]
    processed_data = process_data(data)
    print(f"原始数据: {data}")
    print(f"处理后的数据: {processed_data}")

    # 测试异常情况
    try:
        # 这里故意创建一个可能出错的情况
        test_list = [1, 2, 3]
        print(f"测试列表访问: {test_list[5]}")  # 这会引发IndexError
    except Exception as e:
        print(f"捕获到异常: {e}")


if __name__ == "__main__":
    main()
