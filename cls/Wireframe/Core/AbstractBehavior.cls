Class Wireframe.Core.AbstractBehavior [ Abstract ]
{

Property Recorder As Wireframe.Core.BehaviorRecorder [ Private ];

Method %OnNew(recorder As Wireframe.Core.BehaviorRecorder)
{
  set ..Recorder = recorder
  return $$$OK
}

}
