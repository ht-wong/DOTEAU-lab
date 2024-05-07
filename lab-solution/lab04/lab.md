# create workspaces

terraform workspace new prod
terraform workspace new dev
terraform workspace new stage

# 先在global文件夹中构建remote-state，
# 然后分别配置不同的三个 tfvars，使用不同的tfvar，构建三套系统。
# 然后模拟发布流程
# 先进行dev的测试，然后进行stage的测试。
# 总之使用将workspace的几个场景都使用一遍。
# https://qix8lapkx2.feishu.cn/wiki/EBqcwhgmAiNBvLk6IQac0PJfnVl?from=from_copylink