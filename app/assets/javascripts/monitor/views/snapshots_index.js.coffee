class @Monitor_SnapshotsIndexView extends Backbone.View
  render: =>
    newest_snapshot = _.max snapshots.models, (mod) -> mod.get('id')
    $("#snapshot_time").html(newest_snapshot.get('time'))
    $("#cpu").html(newest_snapshot.get('cpu'))
    $("#mem").html(newest_snapshot.get('mem'))
    sorted_models = _.sortBy(snapshots.models, (mod) -> mod.get('id'))
    cpu_numbers = _.map(sorted_models, (mod) -> mod.get('cpu')).join(' ')
    mem_numbers = _.map(sorted_models, (mod) -> mod.get('mem')).join(' ')
    $("#cpu_spark").html(cpu_numbers)
    generateSparkline($("#cpu_spark")[0])
    $("#mem_spark").html(mem_numbers)
    generateSparkline($("#mem_spark")[0])
