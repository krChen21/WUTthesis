# `wutthesis` 武汉理工大学学位论文 LaTeX 模板 

## 模板下载

* 页面右边点击：**Clone or download -> Download Zip**
* 字体配置请看：(https://github.com/mohuangrui/ucasthesis/wiki/字体配置#linuxoverleaf-系统的字体配置)

## 请知悉

* "wutthesis"完全依托于ucasthesis,本人只做了细节的修改
* 详细请见：(https://github.com/mohuangrui/ucasthesis)

## 简单介绍

1."Tex"(文件夹):(文件夹内为论文的所有实体内容,正常情况下,这也是使用wutthesis撰写学位论文时,主要关注和修改的一个位置,注：所有文件都必须采用UTF-8编码,否则编译后将出现乱码文本)
* "Tex/Thesis":为主文档,其设计和规划了论文的整体框架,通过对其的阅读可以了解整个论文框架的搭建
* "Tex/Appendix":为附录部分
* "Tex/Backmatter":致谢以及个人研究成果(本科无需)
* "Tex/Chap_First":正文第一章,一般是引言
* "Tex/Chap_Second":正文第二章
* "Tex/Frontinfo":中英文封面,论文封面会根据英文学位名称如Bachelor、Master、Doctor、Postdoctor自动切换为相应的格式
* "Tex/Frontmatter":中英文摘要
* "Tex/Mainmatter":插入正文部分,在此插入"Chap_First"、"Chap_Second"等
* "Tex/Prematter":符号列表,在正文之前

2."Style"(文件夹):为字体格式等文件所在,包含wutthesis文档类的定义文件和配置文件,通过对它们的修改可以实现特定的模版设定
* "wutthesis.cls"：文档类定义文件,论文的最核心的格式即通过它来定义的
* "wutthesis.cfg"：文档类配置文件,设定如目录显示为“目~录”而非“目录”
* "artratex.sty": 常用宏包及文档设定,如参考文献样式、文献引用样式、页眉页脚设定等.这些功能具有开关选项,常只需在Thesis.tex中进行启用即可,一般无需修改artratex.sty本身
* "artracom.sty"：自定义命令以及添加宏包的推荐放置位置

3."Img":正文中所需图片文件的所在位置,支持格式有：.jpg, .png, .pdf.其中,"WUT logo.pdf"为武汉理工大学校徽

4."Biblio":参考文献设置
* "Biblio/ckr.bib":参考文件信息库(引用论文时将论文的endnote贴在这里)

