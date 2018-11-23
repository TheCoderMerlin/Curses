public protocol CursesHandlerProtocol {

    // This handler is invoked whenever an interrupt occurs
    func interruptHandler()


    // This handler is invoked whenever the window changes size
    func windowChangedHandler()
}
