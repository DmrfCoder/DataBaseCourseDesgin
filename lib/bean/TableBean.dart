enum TableBeanName { COURSE, STCOURSE, STUDENT, ADMINSC, MYCOURSES }

class TableBean {
  List<String> attributes;

  TableBeanName beanName;

  TableBean(this.beanName, this.attributes);

  TableBean.buildHolder(this.beanName);

  TableBean.buildFromBeanNameAndAttrCount(
      TableBeanName beanName, int attributesCount) {
    attributes = new List(attributesCount);
    this.beanName = beanName;
  }

  updateAttributes(TableBean tableBean) {
    for (int index = 1; index < attributes.length; index++) {
      attributes[index] = tableBean.getWithIndex(index);
    }
  }

  String operator [](int index) {
    return attributes[index];
  }

  getWithIndex(int index) {
    return attributes[index];
  }

  setWithIndex(int index, String values) {
    attributes[index] = values;
  }

  getAttributesCount() {
    return attributes.length;
  }
}
