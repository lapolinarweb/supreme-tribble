import python

ModuleObject thePyramidViewModule() {
    result.getName() = "pyramid.view"
}

Object thePyramidViewConfig() {
    result = thePyramidViewModule().attr("view_config")
}

predicate is_pyramid_view_function(Function func) {
    func.getADecorator().refersTo(_, thePyramidViewConfig(), _)
}

