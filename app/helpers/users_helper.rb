module UsersHelper

  def format_basic_info(time)
    format("%.2f", ((time.hour * 60) + time.min) / 60.0)
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

    def rowspan(attendances)
    if !attendances.map(&:clock_in).push(attendances.map(&:clock_out)).flatten.include?(nil)
      return attendances.size + 1
    else
      return attendances.size
    end
  end

  def attendance_state(attendance)
    if Date.current == attendance.work_on
      return 'In' if attendance.clock_in.nil?
      return 'Out' if attendance.clock_in.present? && attendance.clock_out.nil?
    end
    return false
  end

  def working_times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end

end
