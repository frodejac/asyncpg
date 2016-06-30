cdef class WriteBuffer:
    cdef:
        # Preallocated small buffer
        bint _smallbuf_inuse
        char _smallbuf[_BUFFER_INITIAL_SIZE]

        char *_buf

        # Allocated size
        size_t _size

        # Length of data in the buffer
        size_t _length

        # Number of memoryviews attached to the buffer
        int _view_count

        # True is start_message was used
        bint _message_mode

    cdef inline _check_readonly(self)
    cdef inline len(self)
    cdef inline _ensure_alloced(self, size_t extra_length)
    cdef _reallocate(self, new_size)
    cdef inline start_message(self, char type)
    cdef inline end_message(self)
    cdef write_buffer(self, WriteBuffer buf)
    cdef write_byte(self, char b)
    cdef write_bytestring(self, bytes string)
    cdef write_str(self, str string, str encoding)
    cdef write_cstr(self, char *data, ssize_t len)
    cdef write_int16(self, int16_t i)
    cdef write_int32(self, int32_t i)
    cdef write_int64(self, int64_t i)

    @staticmethod
    cdef WriteBuffer new_message(char type)

    @staticmethod
    cdef WriteBuffer new()


cdef class ReadBuffer:
    cdef:
        # A deque of buffers (bytes objects)
        object _bufs

        # A pointer to the first buffer in `_bufs`
        object _buf0

        # Number of buffers in `_bufs`
        int _bufs_len

        # A read position in the first buffer in `_bufs`
        int _pos0

        # Length of the first buffer in `_bufs`
        int _len0

        # A total number of buffered bytes in ReadBuffer
        int _length

        char _current_message_type
        int _current_message_len
        int _current_message_len_unread
        bint _current_message_ready

    cdef feed_data(self, data)
    cdef inline _ensure_first_buf(self)
    cdef inline read_byte(self)
    cdef inline char* _try_read_bytes(self, int nbytes)
    cdef inline read(self, int nbytes)
    cdef inline read_int32(self)
    cdef inline read_int16(self)
    cdef inline read_cstr(self)
    cdef has_message(self)
    cdef consume_message(self)
    cdef discard_message(self)
    cdef get_message_type(self)
    cdef get_message_length(self)

    @staticmethod
    cdef ReadBuffer new_message_parser(object data)