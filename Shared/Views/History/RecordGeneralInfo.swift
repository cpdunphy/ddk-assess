//
//  RecordGeneralInfo.swift
//  RecordGeneralInfo
//
//  Created by Collin Dunphy on 7/19/21.
//

import SwiftUI

struct RecordGeneralInfo: View {

    @Environment(\.dismiss) var dismiss

    @EnvironmentObject var model: DDKModel

    @AppStorage(StorageKeys.Assessments.HeartRate.unit) var hrUnit: HeartRateDisplayUnit = Defaults.hrDisplayUnit

    var record: AssessmentRecord

    init(_ record: AssessmentRecord) {
        self.record = record
    }

    // MARK: - Body
    var body: some View {
        main
            .navigationTitle("Info")
            #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Text("Done")
                }
            }
    }

    // MARK: - Main
    var main: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                VStack(alignment: .leading) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("Information")
                            .font(.title2)
                            .bold()
                            .padding(.bottom)

                        Spacer()

                        if model.recordIsPinned(record.id) {
                            Image(systemName: "pin.circle.fill")
                                .foregroundColor(.secondary)
                                .symbolRenderingMode(.hierarchical)
                        }
                    }

                    VStack {
                        HStack {

                            Text("Kind")
                                .foregroundColor(.secondary)

                            Spacer()

                            Text("\(Image(systemName: record.type.icon)) \(record.type.title)")

                        }
                        .font(.callout)

                        Divider()

                        HStack {
                            Text("Assessed")
                                .foregroundColor(.secondary)

                            Spacer(minLength: 20)

                            Text(record.date, style: .date) + Text(" at ") + Text(record.date, style: .time)
                        }
                        .font(.callout)

                        Divider()

                        HStack {
                            Text("Duration")
                                .foregroundColor(.secondary)

                            Spacer()

                            Text(record.durationDescription)
                        }
                        .font(.callout)

                        Divider()

                        HStack {
                            Text("Taps")
                                .foregroundColor(.secondary)

                            Spacer()

                            Text("\(record.taps)")
                        }
                        .font(.callout)

                        if record.type == .count {
                            Divider()

                            HStack {
                                Text("Goal")
                                    .foregroundColor(.secondary)

                                Spacer()

                                Text("\(record.goal ?? Defaults.Count.goal)")
                            }
                            .font(.callout)
                        }

                        if record.type == .heartRate {
                            Divider()

                            HStack {
                                Text("Heart Rate")
                                    .foregroundColor(.secondary)

                                Spacer()

                                Text(
                                    "\(Int(HeartRateAssessment.calculateHeartRate(unit: hrUnit, taps: record.taps, duration: record.duration).rounded())) \(hrUnit.rawValue.uppercased())"
                                )
                            }
                            .font(.callout)
                        }
                    }

                }
            }
            .padding()
        }
    }

}

struct RecordGeneralInfo_Previews: PreviewProvider {
    static var previews: some View {
        RecordGeneralInfo(AssessmentRecord(date: Date(), taps: 7, type: .timed, duration: 15))
    }
}
